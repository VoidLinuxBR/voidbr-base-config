#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1091,SC2039,SC2166

ffstr() {
	local red green yellow cyan bold reset
	local arquivo string

	red=$(tput setaf 1)
	green=$(tput setaf 2)
	yellow=$(tput setaf 3)
	cyan=$(tput setaf 6)
	bold=$(tput bold)
	reset=$(tput sgr0)

	if [ "$#" -ne 2 ]; then
		printf '%sUso:%s %sffstr%s %s<arquivo>%s %s<string>%s\n\n' \
			"$bold$yellow" "$reset" "$green" "$reset" \
			"$cyan" "$reset" "$cyan" "$reset"

		printf '%sExemplos:%s\n' "$bold$yellow" "$reset"
		printf '  %sffstr%s %sPKGFILE%s %spipewire%s\n' \
			"$green" "$reset" "$cyan" "$reset" "$red" "$reset"
		printf '  %sffstr%s %s"*.conf"%s %spipewire%s\n' \
			"$green" "$reset" "$cyan" "$reset" "$red" "$reset"
		return 1
	fi

	arquivo="$1"
	string="$2"

	find . -type f -name "$arquivo" \
		-exec grep --color=always -Hn -- "$string" {} +
}
export -f ffstr

ffs() {
	[ "$1" ] || {
		echo "Uso: ffs 'search' '*.doc' | xargs comando"
		echo "     ffs 'def |function ' '*.prg'"
		echo "     ffs '#include' '*.*'"
		echo "     ffs 'search|search|texto' '*.txt' | xargs rm -fv"
		echo "     ffs 'ELF|ASCII|MP4' '*.doc' | xargs cp -v /tmp"
		return
	}
	#   sudo find . -type f -iname '*'"$2"'*' -exec grep --text -iE "($1)" {} +;
	#   sudo grep -r --color=auto -n -iE "($1)" $2;
	#   sudo find . -type d -name bcc-archived -prune -o -type f -iname '*'"$2"'*' -exec grep --color=auto -n -iE "($1)" {} +;
	sudo find . -type d -name bcc-archived -prune -o -type f \( -iname '*'"$2"'*' -and ! -iname '*.pot' -and ! -iname '*.mo' -and ! -iname '*.po' \) -exec grep --color=auto -n -iE "($1)" {} +
}
export -f ffs
