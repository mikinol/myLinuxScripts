if [[ "$PREFIX" != *termux* ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
    echo "$TERM is not supported on this server, using xterm-256color"
    export TERM="xterm-256color"
fi

alias transliterate='uconv -x "Any-Latin"'

rwhich() {
    local cmd_path
    cmd_path=$(command -v "$1") || { echo "Команда '$1' не найдена" >&2; return 1; }
    readlink -f "$cmd_path"
}

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

alias fuseu="fusermount -u"

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

if command -v nix &>/dev/null; then
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

ns() {
  local args=()
  local arg
  for arg in "$@"; do
    if [[ "$arg" == *#* || "$arg" == *:* ]]; then
      args+=("$arg")
    else
      args+=("nixpkgs#$arg")
    fi
  done
  IN_NIX_SHELL=1 nix shell "${args[@]}"
}
_ns() {
  if [ -n "$ZSH_VERSION" ]; then
    # Подменяем имя команды на 'nix' и передаем подкоманду 'shell'
    words=(nix shell "nixpkgs#${words[CURRENT]}")
    CURRENT=3
    _nix
  fi
}
compdef _ns ns

nr() {
  local pkg="$1"
  if [[ "$pkg" == *#* || "$pkg" == *:* ]]; then
    nix run --override-input nixpkgs nixpkgs "$pkg"
  else
    nix run "nixpkgs#$pkg"
  fi
}

nix-graph() {
  if [ -z "$1" ]; then
    echo "Использование: nix-graph <путь_к_пакету_или_симлинку>"
    return 1
  fi

  output_file="$XDG_RUNTIME_DIR/${UID}-nix-graph.svg"

  echo "Генерация графа зависимостей..."
  if nix-store --query --graph "$1" | dot -Tsvg > "$output_file" ; then
    echo "Открытие $output_file..."
    xdg-open "$output_file" & disown
  else
    echo "Ошибка при создании графа."
    return 1
  fi
}

alias ndev="nix develop --override-input nixpkgs nixpkgs -c zsh"
alias nbuild="nix build --impure --no-link --print-out-paths --expr '(import <nixpkgs> {}).callPackage ./default.nix {}'"

adblanconnect() {
  ADB_TARGET=$(avahi-browse -rtp _adb-tls-connect._tcp | awk -F';' '$1=="=" {print $8":"$9; exit}')

  if [ -n "$ADB_TARGET" ]; then
    echo "Найдено устройство: $ADB_TARGET"
    adb connect "$ADB_TARGET"
  else
    echo "ADB устройство не найдено в сети"
  fi
}
fi
