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
  local timenow load distro

  timenow="$(date +'%H:%M')"
  load="$(awk '{print $1 ", " $2 ", " $3}' /proc/loadavg)"
  distro="$(. /etc/os-release && printf '%s %s' "$NAME" "$VERSION_ID")"

  echo -e "${BCyan}Este é o BASH ${BRed}${BASH_VERSION%.*}${BCyan} - DISPLAY em ${BRed}${DISPLAY:-N/A}${NC}\n"
  date

  printf 'Bem-vindo de volta! Agora são %s UTC\n' "$timenow"
  printf "Distribuição      : ${BYellow}%s${NC}\n" "$distro"
  printf "Carga do servidor : ${BYellow}%s${NC}\n" "$load"
  printf "Tempo ligado      :${BYellow}%s${NC}\n" "$(uptime)"
  printf "Usuário           : ${BYellow}%s %s${NC}\n" "$(whoami)" "$(id)"
  printf "Site da distro    : ${BYellow}https://voidbr.org/${NC}\n"
  printf "Ambiente gráfico  : ${BYellow}%s${NC}\n" "${XDG_CURRENT_DESKTOP:-Não iniciado}"
  printf "Tipo de sessão    : ${BYellow}%s${NC}\n" "${XDG_SESSION_TYPE:-Não iniciada}"
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

