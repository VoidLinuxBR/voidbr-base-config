#!/bin/sh
# /etc/runit/core-services/99-voidbr-plymouth-quit.sh
#
# Fim do stage 1: decide quando o plymouth sai, para a tela ir do splash direto
# ao gerenciador de login.
#
# - Sem DM: 'plymouth quit' aqui e o tty1 volta ao texto.
# - lightdm/gdm: eles mesmos encerram o plymouth ('deactivate' + 'quit
#   --retain-splash'); aqui só se espera ele sair.
# - sddm/greetd: o plymouth fica vivo até o greeter subir. Na troca para o tty7
#   ele só solta o DRM e o último quadro segue na tela (o DM deixa o tty7 em
#   KD_GRAPHICS), até o compositor do greeter assumir. Aí 'quit
#   --retain-splash', que sai sem limpar a tela: sem tela preta no meio.
# - lxdm/emptty/slim/xdm/nodm: 'plymouth quit' quando o processo do DM aparece.
#
# agetty-tty1: ele toma o tty1 à força (TIOCSCTTY + vhangup) e mostraria o
# login por cima do splash. Com DM, fica 'down' até o plymouth sair (como o
# getty@.service do systemd, After=plymouth-quit-wait.service). O 'down' criado
# aqui tem a marca .voidbr-plymouth-down ao lado; um 'down' sem a marca é do
# usuário e nunca é apagado.

svdir=/etc/runit/runsvdir/current
[ -d "$svdir" ] || svdir=/etc/runit/runsvdir/default
getty1="$svdir/agetty-tty1"
mark="$getty1/.voidbr-plymouth-down"

# sobra de um boot que não chegou ao fim
[ -e "$mark" ] && rm -f "$getty1/down" "$mark"

command -v plymouth >/dev/null 2>&1 && plymouth --ping 2>/dev/null || return 0

# raiz já está rw: o plymouth grava a duração deste boot (barra de progresso
# dos próximos boots proporcional ao tempo real)
plymouth update-root-fs --read-write 2>/dev/null

_on() {
	[ -e "$svdir/$1" ] && [ ! -e "$svdir/$1/down" ]
}

# 'plymouth quit [--retain-splash]' e espera o plymouthd sair de fato.
# Sem --retain-splash o tty1 volta ao texto com a fonte do kernel: reaplica a
# FONT do /etc/rc.conf, como o 03-console-setup.sh.
_quit() {
	plymouth quit "$@"
	plymouth --wait
	[ "$1" = --retain-splash ] && return 0
	(
		. /etc/rc.conf
		[ -n "$FONT" ] && setfont ${FONT_MAP:+-m "$FONT_MAP"} \
			${FONT_UNIMAP:+-u "$FONT_UNIMAP"} "$FONT" -C /dev/tty1
	) >/dev/null 2>&1
}

# espera um processo cujo nome case com a regex (até 30 s)
_wait_proc() {
	i=0
	until pgrep "$1" >/dev/null; do
		[ $((i += 1)) -gt 150 ] && return 1
		sleep 0.2
	done
}

dm=
for s in lightdm gdm sddm greetd lxdm emptty slim xdm nodm; do
	_on "$s" && dm=$s && break
done

if [ -z "$dm" ]; then
	_quit
	return 0
fi

plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null

# segura o agetty-tty1 até o plymouth sair
if _on agetty-tty1; then
	: >"$mark" && : >"$getty1/down" || rm -f "$mark"
fi

(
	case $dm in
	lightdm | gdm) timeout 30 plymouth --wait ;;
	sddm | greetd)
		[ "$dm" = sddm ] && greeter='^sddm-greeter' || greeter='^(cosmic-greeter|noctalia-greete)'
		if _wait_proc "$greeter"; then
			_quit --retain-splash
		else
			_quit
		fi
		;;
	*)
		[ "$dm" = lxdm ] && proc='^lxdm' || proc="^$dm\$"
		_wait_proc "$proc"
		_quit
		sleep 2 # dá tempo do DM sair do tty1
		;;
	esac
	if [ -e "$mark" ]; then
		rm -f "$getty1/down" "$mark"
		sv up "$getty1"
	fi
) </dev/null >/dev/null 2>&1 &
