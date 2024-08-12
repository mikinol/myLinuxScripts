#!/bin/bash

GPG_KEY_PATH="/etc/apt/trusted.gpg.d/microsoft.gpg"

if [ -f "$GPG_KEY_PATH" ]; then
    echo "GPG ключ microsoft уже установлен."
else
    echo "Скачивание и установка GPG ключа microsoft"
    curl -s https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o "$GPG_KEY_PATH"
    echo "Установка GPG ключа завершена"
fi

echo "Установка GPG ключа microsoft завершена"

echo "Добавление репозитория vscode"
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
echo "Добавление репозитория завершено"

sudo apt update
