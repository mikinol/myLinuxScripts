alias weather=~/mylinuxScripts/weather.sh

alias l="ls -Alh"

alias x=exit

sudo() {
  command sudo env "PATH=$PATH" "$@"
}
