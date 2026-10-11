#!/bin/sh
# /etc/runit/core-services/99-voidbr-plymouth-quit.sh
#
# Roda no fim do stage 1, antes do stage 2 subir qualquer serviço.
#
# - DM gráfico habilitado: 'plymouth quit --retain-splash'
#   O plymouthd encerra e libera a DRM, mas não devolve o VT ao modo texto,
#   então a imagem do splash fica na tela até o greeter assumir o display.
#
# - DM em modo texto (TUI) ou nenhum DM: 'plymouth quit' normal
#   O VT volta ao modo texto, senão o login/TUI ficaria invisível atrás do splash.

command -v plymouth >/dev/null 2>&1 || return 0
plymouth --ping 2>/dev/null || return 0

# Avisa que a raiz já está rw: assim o plymouth grava a duração deste boot
# e a barra de progresso dos próximos boots fica proporcional ao tempo real.
plymouth update-root-fs --read-write 2>/dev/null

gui_dms="sddm lightdm gdm greetd lxdm slim xdm nodm"

svdir=/etc/runit/runsvdir/current
[ -d "$svdir" ] || svdir=/etc/runit/runsvdir/default

for dm in $gui_dms; do
	if [ -e "$svdir/$dm" ] && [ ! -e "$svdir/$dm/down" ]; then
		plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
		plymouth quit --retain-splash
		return 0
	fi
done

plymouth quit
