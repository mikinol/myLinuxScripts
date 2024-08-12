#!/bin/bash

GPG_KEY_PATH="/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg"
REPO_FILE="/etc/apt/sources.list.d/jetbrains-ppa.list"

echo "Установка GPG ключа JetBrains (Unofficial):"

if [ -f "$GPG_KEY_PATH" ]; then
    echo "GPG ключ JetBrains уже установлен."
else
    echo "Скачивание и установка GPG ключа JetBrains"
    curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee "$GPG_KEY_PATH" > /dev/null
    echo "Установка GPG ключа завершена"
fi

echo "Добавление репозитория JetBrains (Unofficial):"

if [ -f "$REPO_FILE" ]; then
    echo "Репозиторий JetBrains уже добавлен."
else
    echo "deb [signed-by=$GPG_KEY_PATH] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee "$REPO_FILE" > /dev/null
    echo "Добавление репозитория завершено"
fi

