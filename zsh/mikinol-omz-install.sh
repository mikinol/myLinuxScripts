#!/usr/bin/env bash

if [ ! -d "$HOME/.oh-my-zsh/" ]; then
    echo "Ошибка: директория ~/.oh-my-zsh/ не найдена." >&2
    exit 1
fi
if [ ! -d "$HOME/mylinuxScripts/" ]; then
    echo "Ошибка: директория ~/mylinuxScripts/ не найдена." >&2
    exit 1
fi

mkdir -p ~/.oh-my-zsh/custom/plugins || exit 1

ln -s $HOME/mylinuxScripts/zsh/mikinol-omz/ $HOME/.oh-my-zsh/custom/plugins/mikinol-omz

echo "mikinol-omz плагин установлен теперь его можно добавить в .zshrc"

if grep -q "^plugins=(" ~/.zshrc; then
    if grep -E '^plugins=\(.*\bmikinol-omz\b' ~/.zshrc >/dev/null; then
        echo "'mikinol-omz' уже есть в списке плагинов"
    else
        sed -i '/^plugins=(/ s/)/ mikinol-omz)/' ~/.zshrc
        echo "'mikinol-omz' добавлен в .zshrc"
    fi
else
    echo "⚠️ Не удалось найти строку plugins=(...) в .zshrc"
    echo "Пожалуйста, добавьте 'mikinol-omz' вручную:"
    echo "plugins=(... mikinol-omz)"
fi

exec zsh
