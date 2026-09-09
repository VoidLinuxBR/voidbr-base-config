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

# Sobe o X automaticamente no login do tty1, para instalações sem display
# manager (modo "xorg minimal": só o servidor X e um xterm, sem WM).
#
# Este arquivo é entregue pelo pacote voidbr-base-config e é igual para todas
# as instalações, então o gatilho não pode estar aqui dentro — quem decide é
# o marcador ~/.voidbr-autostartx, criado pelo instalador apenas no modo
# xorg. Vantagem: por não pertencer a pacote nenhum, o marcador sobrevive a
# reinstalações e atualizações do voidbr-base-config, que reescrevem este
# arquivo. Para desligar, basta remover o marcador; para religar, um touch.
#
# As três condições:
#   -z DISPLAY   evita subir um segundo X quando este .bash_profile é lido
#                por um shell de login aberto dentro do próprio xterm.
#   tty = tty1   restringe ao primeiro console. Os tty2..tty6 seguem em modo
#                texto e são a saída de emergência se o X não subir. Usamos
#                tty(1) em vez de $XDG_VTNR porque essa variável depende do
#                elogind ter populado o ambiente da sessão, o que não é
#                garantido num sistema mínimo.
#   marcador     o interruptor propriamente dito.
#
# Sem exec: ao sair do xterm o X cai e o usuário fica no shell do tty1, em vez
# de ser devolvido à tela de login. Num modo cujo propósito é testar o stack
# gráfico, é preciso poder ler o que falhou.
if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]] && [[ -f ~/.voidbr-autostartx ]]; then
  startx
fi
