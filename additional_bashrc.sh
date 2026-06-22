if [[ "$PREFIX" != *termux* ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
    echo "$TERM is not supported on this server, using xterm-256color"
    export TERM="xterm-256color"
fi

alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

alias rm="rm -i"
alias "rm -r"="rm -rI"
alias "sudo rm"="sudo rm -i"
alias "sudo rm -r"="sudo rm -rI"

alias l="ls -Alh"
alias ff="fastfetch"

alias rm_neovim_config="rm -Ivrf ~/.local/share/nvim/* ~/.local/state/nvim/* ~/.cache/nvim ~/.config/nvim/*"

alias chrome="NIXPKGS_ALLOW_UNFREE=1 nix-shell -p google-chrome --run \"NIXOS_OZONE_WL=1 google-chrome-stable --ozone-platform-hint=auto --ozone-platform=wayland\""

nsh() {
  if [ $# -gt 0 ]; then
    nix-shell -p "$@" --run zsh
  else
    nix-shell --run zsh
  fi
}

_nsh() {
    if [ -n "$ZSH_VERSION" ]; then
        # shellcheck disable=SC2180
        words=(nix-shell -p "${words[@][2,-1]}")
        CURRENT=$((CURRENT + 1))
        _nix-shell
   fi
}
compdef _nsh nsh

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

alias cdtemp='cd $(mktemp -d)'
