#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1091,SC2039,SC2166

ffb-old() {
  local filepath="${1:-.}"      # Caminho a ser pesquisado (padrão: diretório atual)
  local num_arquivos="${2:-10}" # Número de arquivos a exibir (padrão: 10)
  local resultado

  # Formatação de cores
  local green="\033[1;32m"
  local blue="\033[1;34m"
  local reset="\033[0m"
  # Cores com tput
  local bold=$(tput bold)
  local yellow=${bold}$(tput setaf 3)  # amarelo
  local red=$(tput setaf 1)     # vermelho
  local magenta=$(tput setaf 5) # magenta
  local green=$(tput setaf 2)   # verde
  local blue=${bold}$(tput setaf 4)    # azul
  local reset=$(tput sgr0)      # reset

  # Comando find para localizar os maiores arquivos
#  resultado=$(find "$filepath" -type d -name .git -prune -o -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n "$num_arquivos")

resultado=$(find "$filepath" -type d -name .git -prune -o -type f -exec du -h {} + 2>/dev/null \
  | sort -rh \
  | head -n "$num_arquivos" \
  | while read -r size file; do
      # pegar permissões e owner:group
#      perms=$(stat -c "%a" "$file")
#      owner_group=$(stat -c "%U:%G" "$file")

      # imprimir colorido e alinhado
#      printf "%s%3s%s %s%4s%s %s%12s%s %s%6s%s %s%s%s\n" \
#        "$yellow" " " "$reset" \
#        "$red" "$perms" "$reset" \
#        "$magenta" "$owner_group" "$reset" \
#        "$green" "$size" "$reset" \
#        "$blue" "$file" "$reset"

      printf "%s%3s%s %s%6s%s %s%s%s\n" \
        "$yellow" " " "$reset" \
        "$green" "$size" "$reset" \
        "$blue" "$file" "$reset"
    done)

  # Exibir o resultado formatado
  echo -e "=== Resultado ==="
  echo -e "$resultado" | nl

  # Exibir os parâmetros utilizados
  echo -e "=== Parâmetros informados ==="
  echo -e "Caminho               : ${green}${filepath}${reset}"
  echo -e "Número de arquivos    : ${green}${num_arquivos}${reset}"
  echo -e "Uso: ${blue}ffb \"*.c\"${reset}, ${blue}ffb \"*.c\" 10${reset}"
  echo -e "     ${blue}ffb . ${reset}"
  echo -e "     ${blue}ffb /var/log 20 ${reset}"
  echo -e "     ${blue}ffb "*.log" ${reset}"
}
export -f ffb-old

ffb() {
  local filepath="${1:-.}"
  local num_arquivos="${2:-10}"

 # Cores com tput
  local bold=$(tput bold)
  local yellow=${bold}$(tput setaf 3)  # amarelo
  local red=$(tput setaf 1)     # vermelho
  local magenta=$(tput setaf 5) # magenta
  local green=$(tput setaf 2)   # verde
  local blue=${bold}$(tput setaf 4)    # azul
  local reset=$(tput sgr0)      # reset
  local seq=1

  # Exibir o resultado formatado
  echo -e "=== Resultado ==="
  # Gerar tabela limpa
  find "$filepath" -type d -name .git -prune -o -type f -print0 | \
    xargs -0 du -h 2>/dev/null | sort -rh | head -n "$num_arquivos" | \
    while read -r size file; do
      [[ ! -f "$file" ]] && continue
      perms=$(stat -c "%a" "$file")
      owner_group=$(stat -c "%U:%G" "$file")
#      printf "%s\t%s\t%s\t%s\t%s\n" "${yellow}$seq" "${red}$size" "${magenta}$perms" "${reset}$owner_group" "${blue}$file"
      # calcular largura real sem cores
      seq_fmt=$(printf "%-3s" "$seq")
      perms_fmt=$(printf "%-3s" "$perms")
      owner_fmt=$(printf "%-0s" "$owner_group")
      size_fmt=$(printf "%-5s" "$size")

      printf "%s%s%s %s%s%s %s%s%s %s%s%s %s%s%s\n" \
        "$yellow" "$seq_fmt" "$reset" \
        "$red" "$perms_fmt" "$reset" \
        "$magenta" "$owner_fmt" "$reset" \
        "$green" "$size_fmt" "$reset" \
        "$blue" "$file" "$reset"
      seq=$((seq+1))
    done
#    done | column -t | awk -v y="$yellow" -v r="$red" -v m="$magenta" -v g="$green" -v b="$blue" -v rs="$reset" 'NR==1 {print; next} {printf "%s%s%s  %s%s%s  %s%s%s  %s%s%s  %s%s%s\n", y,$1,rs,r,$2,rs,m,$3,rs,g,$4,rs,b,$5,rs}'

 # Exibir os parâmetros utilizados
  echo -e "=== Parâmetros informados ==="
  echo -e "Caminho               : ${green}${filepath}${reset}"
  echo -e "Número de arquivos    : ${green}${num_arquivos}${reset}"
  echo -e "Uso: ${blue}ffb \"*.c\"${reset}, ${blue}ffb \"*.c\" 10${reset}"
  echo -e "     ${blue}ffb . ${reset}"
  echo -e "     ${blue}ffb /var/log 20 ${reset}"
  echo -e "     ${blue}ffb "*.log" ${reset}"
}
export -f ffb

