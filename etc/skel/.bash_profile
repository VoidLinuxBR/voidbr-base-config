#
# ~/.bash_profile
#

# Bold
BBlack='\e[1;30m'  # Black
BRed='\e[1;31m'    # Red
BGreen='\e[1;32m'  # Green
BYellow='\e[1;33m' # Yellow
BBlue='\e[1;34m'   # Blue
BPurple='\e[1;35m' # Purple
BCyan='\e[1;36m'   # Cyan
BWhite='\e[1;37m'  # White
NC="\e[m"          # Color Reset

function Welcome() {
  timenow="$(date +'%H:%M')"
  load="$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)"

  echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}- DISPLAY on ${BRed}$DISPLAY${NC}\n"
  date
  timenow="$(date +'%H:%M')"
  load="$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)"
  printf 'Welcome back! The time now is %s UTC\n' "$timenow"
  printf "Server load    :  ${BYellow}%s${NC}\n" "$load"
  printf "Server Uptime  : ${BYellow}%s\n${NC}" "$(uptime)"
  printf "User           :  ${BYellow}%s %s\n${NC}" "$(whoami)" "$(id)"
  printf "Link to distro :  ${BYellow}https://voidbr.org/ \n${NC}"
  printf "Desktop        :  ${BYellow}$XDG_CURRENT_DESKTOP \n${NC}"
  printf "Session        :  ${BYellow}$XDG_SESSION_TYPE \n${NC}"
}
export -f Welcome

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

