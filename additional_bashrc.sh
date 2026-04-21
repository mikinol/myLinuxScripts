alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

alias l="ls -Alh"

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
