#!/bin/bash

GPG_KEY_PATH="/etc/apt/trusted.gpg.d/google.gpg"
REPO_FILE="/etc/apt/sources.list.d/google.list"

echo "Установка GPG ключа Google Chrome:"

if [ -f "$GPG_KEY_PATH" ]; then
    echo "GPG ключ Google Chrome уже установлен."
else
    echo "Скачивание и установка GPG ключа Google Chrome"
    curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o "$GPG_KEY_PATH"
    echo "Установка GPG ключа завершена"
fi

echo "Добавление репозитория Google Chrome:"

if [ -f "$REPO_FILE" ]; then
    echo "Репозиторий Google Chrome уже добавлен."
else
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee "$REPO_FILE" > /dev/null
    echo "Добавление репозитория завершено"
fi

sudo apt update
