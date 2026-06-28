#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Inicia o Sway automaticamente no TTY1
#if [ -z "$WAYLAND_DISPLAY" ] &&
#  [ "${XDG_VTNR:-0}" -eq 1 ]; then
#  # Variáveis para garantir que aplicativos GTK/Qt respeitem o tema e o Wayland
#  export QT_QPA_PLATFORM=wayland
#  export MOZ_ENABLE_WAYLAND=1
#
#  exec sway
#fi

#if [[ -z "$DISPLAY" ]]; then
#	exec startx &
#	exec start lxmd &
#fi
