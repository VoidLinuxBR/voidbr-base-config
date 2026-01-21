#!/bin/sh

#bk="$HOME/.config/gtk-3.0/bookmarks"
## só continua se existir o arquivo
#[ -f "$bk" ] || exit 0
## só faz a substituição se ainda contém placeholder
#grep -q "__HOME__" "$bk" || exit 0
## substitui placeholder pelo $HOME real
#sed -i "s|__HOME__|$HOME|g" "$bk"

# para todos os usuários
for u in /home/*; do
	[ -d "$u" ] || continue
	bk="$u/.config/gtk-3.0/bookmarks"
	[ -f "$bk" ] || continue
	sed -i "s|__HOME__|$u|g" "$bk"
done
