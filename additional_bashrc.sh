alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

alias l="ls -Alh"

listen_pipe() {
    local pipe_name="/tmp/${1:-mypipe}"

    # Создаем именованный канал, если его еще нет
    if [[ ! -p "$pipe_name" ]]; then
        touch "$pipe_name"
        echo "Pipe created: $pipe_name"
    else
        echo "Using existing pipe: $pipe_name"
    fi

    # Настраиваем ловушку: при выходе (EXIT) или прерывании (INT/TERM) удалить файл
    trap 'rm -f "$pipe_name"; return' INT TERM EXIT

    echo "Listening... (Press Ctrl+C to stop)"
    
    # Запускаем чтение в бесконечном цикле, чтобы канал не закрывался 
    # после того, как пишущая программа закончит работу
    while true; do
        tail -f "$pipe_name"
    done
}

nsh() {
  if [ $# -gt 0 ]; then
    nix-shell -p "$@" --run zsh
  else
    nix-shell --run zsh
  fi
}

_nsh_packages() {
    # Мы просто переиспользуем логику дополнения для nix-shell
    # флаг -p (или --packages) заставляет дополнять имена пакетов
    _arguments '*:package name:_nix_packages'
}

# Привязываем дополнение к вашей функции
compdef '_dispatch nix-shell nix-shell' nsh
