alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read().strip()))"'
alias transliterate='uconv -x "Any-Latin"'

# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'

nsh() {
  if [ $# -gt 0 ]; then
    nix-shell -p "$@" --run zsh
  else
    nix-shell --run zsh
  fi
}
