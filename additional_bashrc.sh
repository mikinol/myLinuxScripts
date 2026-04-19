alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

nsh() {
  if [ $# -eq 0 ]; then
    echo "Ошибка: Укажите хотя бы один пакет (например: nsh hello)"
    return 1
  fi

  # Запускаем nix-shell, интерпретируя все аргументы ($@) 
  # строго как список пакетов для флага -p.
  # Использование -- перед "$@" предотвращает передачу 
  # дополнительных флагов самому nix-shell.
  nix-shell -p "$@" --run zsh
}
