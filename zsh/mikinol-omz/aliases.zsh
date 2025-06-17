alias weather=~/mylinuxScripts/weather.sh

alias l="ls -Alh"

alias x=exit

alias py=python3

sudo() {
  command sudo env "PATH=$PATH" "$@"
}
