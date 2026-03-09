# Подгружаем алиасы
source "${0:h}/aliases.zsh"

# NeoVim редактор по умолчанию
export EDITOR='nvim'

# Проверяем TERM
source "${0:h}/check-term.zsh"

# Добавлем copyfile
source "${0:h}/copyfile.zsh"

export PATH=$HOME/myLinuxScripts/bin:$PATH

export GOPATH="$HOME/.cache/go/"

ZCOMPDUMP_PATH="$HOME/.cache/zcompdump"
mkdir -p "$ZCOMPDUMP_PATH"
export ZSH_COMPDUMP="$ZCOMPDUMP_PATH/$(hostname)-$ZSH_VERSION"

