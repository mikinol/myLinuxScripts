if [[ "$PREFIX" != *termux* ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
    echo "$TERM is not supported on this server, using xterm-256color"
    export TERM="xterm-256color"
fi

export PATH=$HOME/myLinuxScripts/bin:$PATH
source "${0:h}/additional_bashrc.sh"
