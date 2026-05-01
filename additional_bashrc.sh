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
