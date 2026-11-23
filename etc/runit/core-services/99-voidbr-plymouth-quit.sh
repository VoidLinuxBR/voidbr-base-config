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
#   O splash fica na tela durante o stage 2 (o tty1 segue em modo gráfico, então
#   o login do agetty-tty1 não aparece) e um processo em segundo plano espera o
#   DM subir para só então dar o 'plymouth quit'. Isso cobre também a espera do
#   sddm pelo dbus ('sv check dbus || exit 1' no run, que o runsv repete a cada 1 s).
#
#   'plymouth quit' normal, sem --retain-splash: o --retain-splash deixa o tty1
#   em KD_GRAPHICS e o kernel ignora troca de VT saindo de um VT assim
#   (change_console em drivers/tty/vt/vt_ioctl.c); o sddm do Void sobe no tty7.
#
# - Nenhum DM habilitado (login em texto) ou DM desconhecido:
#   'plymouth quit' normal aqui, para o VT voltar ao modo texto.

command -v plymouth >/dev/null 2>&1 || return 0
plymouth --ping 2>/dev/null || return 0

# Avisa que a raiz já está rw: assim o plymouth grava a duração deste boot
# e a barra de progresso dos próximos boots fica proporcional ao tempo real.
plymouth update-root-fs --read-write 2>/dev/null

svdir=/etc/runit/runsvdir/current
[ -d "$svdir" ] || svdir=/etc/runit/runsvdir/default

_voidbr_dm_enabled() {
	[ -e "$svdir/$1" ] && [ ! -e "$svdir/$1/down" ]
}

for dm in lightdm gdm; do
	if _voidbr_dm_enabled "$dm"; then
		plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
		return 0
	fi
done

# serviço:processo (nome que o pgrep -x enxerga depois do exec no run)
for entry in sddm:sddm greetd:greetd lxdm:'lxdm|lxdm-binary' emptty:emptty \
	slim:slim xdm:xdm nodm:nodm; do
	dm="${entry%%:*}"
	proc="${entry#*:}"
	_voidbr_dm_enabled "$dm" || continue

	plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
	(
		# Até 30 s (300 x 0,1 s): DM que não sobe não pode deixar o splash preso.
		i=0
		while [ "$i" -lt 300 ]; do
			pgrep -x "$proc" >/dev/null 2>&1 && break
			sleep 0.1
			i=$((i + 1))
		done
		plymouth quit
	) </dev/null >/dev/null 2>&1 &
	return 0
done

plymouth quit
