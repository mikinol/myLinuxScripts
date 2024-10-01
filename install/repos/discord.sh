#!/bin/bash

echo "Установка gpg ключа для discord"
sudo -E gpg --no-default-keyring --keyring=/usr/share/keyrings/javinator9889-ppa-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys 08633B4AAAEB49FC
echo "Ключ установлен"

echo "Добавление репозиториев в sources list"

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com all main" | sudo tee -a /etc/apt/sources.list.d/javinator9889-ppa.list

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com public-beta main" | sudo tee -a /etc/apt/sources.list.d/javinator9889-ppa.list

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com canary main" | sudo tee -a /etc/apt/sources.list.d/javinator9889-ppa.list

echo "Репозитории добавлены"
sudo apt update
