# Подгружаем алиасы
source "${0:h}/aliases.zsh"

# NeoVim редактор по умолчанию
export EDITOR='nvim'

# Проверяем TERM
source "${0:h}/check-term.zsh"

# Добавлем copyfile
source "${0:h}/copyfile.zsh"
