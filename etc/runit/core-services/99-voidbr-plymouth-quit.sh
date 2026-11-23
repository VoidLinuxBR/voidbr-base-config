#!/bin/sh
# /etc/runit/core-services/99-voidbr-plymouth-quit.sh
#
# Roda no fim do stage 1, antes do stage 2 subir qualquer serviço.
#
# - lightdm e gdm sabem lidar com o plymouth sozinhos: fazem 'plymouth deactivate',
#   sobem o servidor gráfico e só então 'plymouth quit --retain-splash'.
#   Nesses casos o plymouth NÃO é encerrado aqui.
#
# - sddm e greetd não falam com o plymouth. O splash fica na tela durante o
#   stage 2 e um processo em segundo plano espera o greeter subir para só então
#   dar 'plymouth quit --retain-splash'. Até lá o último quadro do splash segue
#   na tela mesmo depois da troca para o tty7 (detalhes no laço do sddm/greetd
#   abaixo), sem tela preta enquanto o compositor do greeter inicializa.
#   Com o plymouth vivo, a troca de VT passa por ele (VT_PROCESS); ao sair, o
#   tty1 fica em VT_PROCESS com dono morto e o kernel o devolve ao modo texto
#   na próxima troca (reset_vc em drivers/tty/vt/vt_ioctl.c).
#
# - lxdm, emptty, slim, xdm e nodm: 'plymouth quit' normal quando o processo
#   do DM aparece.
#
# - agetty-tty1: o agetty toma o tty1 à força (TIOCSCTTY + vhangup) e tira o
#   tty1 do plymouth, mostrando o /etc/issue e o login antes do DM subir.
#   Igual ao systemd (getty@.service tem After=plymouth-quit-wait.service), com
#   DM habilitado o agetty-tty1 só sobe depois que o plymouth sai: ele fica
#   'down' no boot e o processo em segundo plano dá 'sv up' no fim.
#   O 'down' criado aqui tem a marca .voidbr-plymouth-down ao lado; um 'down'
#   que o usuário criou (sem a marca) nunca é apagado.
#
# - Nenhum DM habilitado (login em texto) ou DM desconhecido:
#   'plymouth quit' normal aqui, para o VT voltar ao modo texto.

svdir=/etc/runit/runsvdir/current
[ -d "$svdir" ] || svdir=/etc/runit/runsvdir/default

getty1="$svdir/agetty-tty1"
getty1_mark="$getty1/.voidbr-plymouth-down"

# Sobra de um boot que não chegou ao fim: devolve o agetty-tty1 ao normal.
if [ -e "$getty1_mark" ]; then
	rm -f "$getty1/down" "$getty1_mark"
fi

command -v plymouth >/dev/null 2>&1 || return 0
plymouth --ping 2>/dev/null || return 0

# Avisa que a raiz já está rw: assim o plymouth grava a duração deste boot
# e a barra de progresso dos próximos boots fica proporcional ao tempo real.
plymouth update-root-fs --read-write 2>/dev/null

_voidbr_dm_enabled() {
	[ -e "$svdir/$1" ] && [ ! -e "$svdir/$1/down" ]
}

# Encerra o plymouth (argumentos extras vão para o 'plymouth quit'), espera o
# plymouthd sumir de fato (até 2 s) e reaplica a fonte do console no tty1:
# ao sair, o plymouth costuma voltar a fonte para a padrão do kernel.
# Mesma fonte que o 03-console-setup.sh aplica (FONT do /etc/rc.conf).
_voidbr_plymouth_quit() {
	plymouth quit "$@"
	i=0
	while [ "$i" -lt 20 ]; do
		pgrep -x plymouthd >/dev/null 2>&1 || break
		sleep 0.1
		i=$((i + 1))
	done
	(
		. /etc/rc.conf 2>/dev/null
		[ -n "$FONT" ] && setfont ${FONT_MAP:+-m "$FONT_MAP"} \
			${FONT_UNIMAP:+-u "$FONT_UNIMAP"} "$FONT" -C /dev/tty1
	) >/dev/null 2>&1
}

# Segura o agetty-tty1 (se estiver habilitado) até o plymouth sair.
_voidbr_hold_getty1() {
	_voidbr_dm_enabled agetty-tty1 || return 0
	: >"$getty1_mark" && : >"$getty1/down" || rm -f "$getty1_mark"
}

# Solta o agetty-tty1 segurado acima. Roda no segundo plano, já no stage 2:
# tenta o 'sv up' por até 10 s, até o runsv do agetty-tty1 estar de pé.
_voidbr_release_getty1() {
	[ -e "$getty1_mark" ] || return 0
	rm -f "$getty1/down" "$getty1_mark"
	i=0
	while [ "$i" -lt 100 ]; do
		sv up "$getty1" >/dev/null 2>&1 && return 0
		sleep 0.1
		i=$((i + 1))
	done
}

for dm in lightdm gdm; do
	_voidbr_dm_enabled "$dm" || continue

	plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
	_voidbr_hold_getty1
	(
		# Quem encerra é o próprio DM; aqui só espera o plymouth sair
		# (até 30 s) para soltar o agetty-tty1.
		i=0
		while [ "$i" -lt 300 ]; do
			plymouth --ping 2>/dev/null || break
			sleep 0.1
			i=$((i + 1))
		done
		_voidbr_release_getty1
	) </dev/null >/dev/null 2>&1 &
	return 0
done

# sddm e greetd: o plymouth fica vivo até o greeter subir.
# Quando o DM troca para o tty7, o plymouth recebe o aviso de troca de VT
# (VT_PROCESS), só solta o DRM (drmDropMaster) e o último quadro do splash
# continua na tela: o DM deixa o tty7 em KD_GRAPHICS, então o fbcon não
# desenha nada por cima. O compositor do greeter assume o vídeo direto desse
# quadro. Só então 'plymouth quit --retain-splash', que sai sem limpar a tela
# (sem ele o plymouth apagaria o splash e devolveria o VT).
# serviço:processo do greeter (regex do pgrep sobre o nome do processo;
# o nome é cortado em 15 caracteres)
for entry in sddm:'^sddm-greeter' greetd:'^(cosmic-greeter|noctalia-greete)'; do
	dm="${entry%%:*}"
	greeter="${entry#*:}"
	_voidbr_dm_enabled "$dm" || continue

	plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
	_voidbr_hold_getty1
	(
		# Até 30 s (300 x 0,1 s): greeter que não sobe não pode deixar o splash preso.
		i=0
		while [ "$i" -lt 300 ]; do
			pgrep "$greeter" >/dev/null 2>&1 && break
			sleep 0.1
			i=$((i + 1))
		done
		if [ "$i" -lt 300 ]; then
			_voidbr_plymouth_quit --retain-splash
		else
			_voidbr_plymouth_quit
		fi
		sleep 2
		_voidbr_release_getty1
	) </dev/null >/dev/null 2>&1 &
	return 0
done

# Outros DMs: encerra quando o processo do DM aparece.
# serviço:processo (nome que o pgrep -x enxerga depois do exec no run)
for entry in lxdm:'lxdm|lxdm-binary' emptty:emptty slim:slim xdm:xdm nodm:nodm; do
	dm="${entry%%:*}"
	proc="${entry#*:}"
	_voidbr_dm_enabled "$dm" || continue

	plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
	_voidbr_hold_getty1
	(
		# Até 30 s (300 x 0,1 s): DM que não sobe não pode deixar o splash preso.
		i=0
		while [ "$i" -lt 300 ]; do
			pgrep -x "$proc" >/dev/null 2>&1 && break
			sleep 0.1
			i=$((i + 1))
		done
		_voidbr_plymouth_quit
		# Dá tempo do DM sair do tty1.
		sleep 2
		_voidbr_release_getty1
	) </dev/null >/dev/null 2>&1 &
	return 0
done

_voidbr_plymouth_quit
