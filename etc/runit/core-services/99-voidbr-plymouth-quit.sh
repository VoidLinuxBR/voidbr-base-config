#!/bin/sh
# /etc/runit/core-services/99-voidbr-plymouth-quit.sh
#
# Roda no fim do stage 1, antes do stage 2 subir qualquer serviço.
#
# - lightdm e gdm sabem lidar com o plymouth sozinhos: fazem 'plymouth deactivate',
#   sobem o servidor gráfico e só então 'plymouth quit --retain-splash'.
#   Nesses casos o plymouth NÃO é encerrado aqui, para a transição ficar sem tela preta.
#
# - Qualquer outro DM (sddm, greetd, lxdm, ly, ...) ou login em texto:
#   'plymouth quit' normal aqui, antes do DM subir, para ele conseguir pegar a DRM
#   e o VT voltar ao modo texto.

command -v plymouth >/dev/null 2>&1 || return 0
plymouth --ping 2>/dev/null || return 0

# Avisa que a raiz já está rw: assim o plymouth grava a duração deste boot
# e a barra de progresso dos próximos boots fica proporcional ao tempo real.
plymouth update-root-fs --read-write 2>/dev/null

svdir=/etc/runit/runsvdir/current
[ -d "$svdir" ] || svdir=/etc/runit/runsvdir/default

for dm in lightdm gdm; do
	if [ -e "$svdir/$dm" ] && [ ! -e "$svdir/$dm/down" ]; then
		plymouth display-message --text="Iniciando a interface gráfica..." 2>/dev/null
		return 0
	fi
done

plymouth quit
