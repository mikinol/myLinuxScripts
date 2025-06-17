#!/usr/bin/env bash

if [ ! -d "$HOME/.oh-my-zsh/" ]; then
    echo "Ошибка: директория ~/.oh-my-zsh/ не найдена." >&2
    exit 1
fi

mkdir -p ~/.oh-my-zsh/custom/plugins || exit 1

git clone https://github.com/z-shell/zsh-lsd.git --depth 1 ~/.oh-my-zsh/custom/plugins/zsh-lsd || exit 1

echo "zsh-lsd плагин установлен теперь его можно добавить в .zshrc"

if grep -q "^plugins=(" ~/.zshrc; then
    if grep -E '^plugins=\(.*\bzsh-lsd\b' ~/.zshrc >/dev/null; then
        echo "'zsh-lsd' уже есть в списке плагинов"
    else
        sed -i '/^plugins=(/ s/)/ zsh-lsd)/' ~/.zshrc
        echo "'zsh-lsd' добавлен в .zshrc"
    fi
else
    echo "⚠️ Не удалось найти строку plugins=(...) в .zshrc"
    echo "Пожалуйста, добавьте 'zsh-lsd' вручную:"
    echo "plugins=(... zsh-lsd)"
fi

exec zsh
