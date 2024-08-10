#!/bin/bash

echo "Добавление ppa репозитория neovim"
sudo add-apt-repository ppa:neovim-ppa/unstable
echo "Добавление репозитория завершено"

echo "Добавление ppa репозитория terminator"
sudo add-apt-repository ppa:mattrose/terminator
echo "Добавление репозитория завершено"

echo "Установка GPG ключа microsoft:"
if cd /tmp/; then
    echo "Скачивание GPG ключа microsoft"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    echo "Ключ скачан"
    echo "Устновка GPG ключа microsoft в систему"
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "Установка завершена"
    echo "Удаление временных файлов"
    rm microsoft.gpg
else
    echo "Не удалось перейти в /tmp/. Пожалуйста, выполните следующие команды вручную:"
    echo "cd /tmp/"
    echo "curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg"
    echo "sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/"
    echo "rm microsoft.gpg"
    read -n 1 -r -p "Для продолжения нажмите enter..."
fi
echo "Установка GPG ключа microsoft завершена"

echo "Добавление репозитория vscode"
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
echo "Добавление репозитория завершено"

echo "Скачивание и установка GPG ключа google"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
echo "Установка GPG ключа google завершена"

echo "Добавление репозитория Google Chrome"
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
echo "Добавление репозитория завершено"

echo "Установка GPG ключа JetBrains (Unofficial)"
echo "Скачивание и установка GPG ключа JetBrains (Unofficial)"
curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
echo "Добавление репозитория JetBrains (Unofficial)"
echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
echo "Добавление репозитория завершено"

sudo apt update
