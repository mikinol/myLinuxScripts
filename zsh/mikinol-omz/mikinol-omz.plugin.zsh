# Подгружаем алиасы
source "${0:h}/aliases.zsh"

# Добавляем себя в PATH
export PATH="${0:h}/mikinol-bin:$PATH"

# NeoVim редактор по умолчанию
export EDITOR='nvim'

# Проверяем TERM
source "${0:h}/check-term.zsh"
