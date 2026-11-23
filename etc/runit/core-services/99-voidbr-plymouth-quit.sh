#!/bin/sh
# /etc/runit/core-services/99-voidbr-plymouth-quit.sh
#
# Roda no fim do stage 1, antes do stage 2 subir qualquer serviço.
#
# - lightdm e gdm sabem lidar com o plymouth sozinhos: fazem 'plymouth deactivate',
#   sobem o servidor gráfico e só então 'plymouth quit --retain-splash'.
#   Nesses casos o plymouth NÃO é encerrado aqui.
#
# - sddm, greetd, lxdm, emptty, slim, xdm e nodm não falam com o plymouth.
#   O splash fica na tela durante o stage 2 e um processo em segundo plano
#   espera o DM subir para só então dar o 'plymouth quit'. Isso cobre também a
#   espera do sddm pelo dbus ('sv check dbus || exit 1' no run, que o runsv
#   repete a cada 1 s).
#
#   'plymouth quit' normal, sem --retain-splash: o --retain-splash deixa o tty1
#   em KD_GRAPHICS e o kernel ignora troca de VT saindo de um VT assim
#   (change_console em drivers/tty/vt/vt_ioctl.c); o sddm do Void sobe no tty7.
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

# serviço:processo (nome que o pgrep -x enxerga depois do exec no run)
for entry in sddm:sddm greetd:greetd lxdm:'lxdm|lxdm-binary' emptty:emptty \
	slim:slim xdm:xdm nodm:nodm; do
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
		plymouth quit
		# Dá tempo do DM sair do tty1 (o sddm leva ~0,3 s até o tty7).
		sleep 2
		_voidbr_release_getty1
	) </dev/null >/dev/null 2>&1 &
	return 0
done

plymouth quit
