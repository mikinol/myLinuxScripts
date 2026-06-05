alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

alias l="ls -Alh"

alias rm="rm -i"
alias "rm -f"="rm -fi"
alias "rm -r"="rm -ri"
alias "rm -rf"="rm -rfi"
alias "sudo rm"="sudo rm -i"
alias "sudo rm -f"="sudo rm -fi"
alias "sudo rm -r"="sudo rm -ri"
alias "sudo rm -rf"="sudo rm -rfi"

alias l="ls -Alh"
alias ff="fastfetch"

alias chrome="NIXPKGS_ALLOW_UNFREE=1 nix-shell -p google-chrome --run \"NIXOS_OZONE_WL=1 google-chrome-stable --ozone-platform-hint=auto --ozone-platform=wayland\""

nsh() {
  if [ $# -gt 0 ]; then
    nix-shell -p "$@" --run zsh
  else
    nix-shell --run zsh
  fi
}

_nsh_packages() {
    _arguments '*:package name:_nix_packages'
}
compdef '_dispatch nix-shell nix-shell' nsh

sixel() {
    if [ $# -eq 0 ]; then
        magick - sixel:-
    else
        for file in "$@"; do
            magick "$file" sixel:-
        done
    fi
}

tou8() {
    if [ -z "$1" ]; then
        echo "Ошибка: Укажи имя файла. Пример: tou8 main.cpp"
        return 1
    fi

    if [ ! -f "$1" ]; then
        echo "Ошибка: Файл '$1' не найден."
        return 1
    fi

    # shellcheck disable=SC2155
    local temp_file=$(mktemp)
    
    if iconv -f windows-1251 -t utf-8 "$1" -o "$temp_file" 2>/dev/null; then
        mv "$temp_file" "$1"
        echo "Отлично! Файл '$1' успешно конвертирован в UTF-8."
    else
        rm -f "$temp_file"
        echo "Что-то пошло не так. Возможно, файл уже в UTF-8 или поврежден."
        return 1
    fi
}
