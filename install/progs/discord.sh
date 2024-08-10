#!/bin/bash

echo "Установка Discord"
if cd /tmp/; then
    echo "Скачивание discord_latest.deb"
    curl -L -o discord_latest.deb --retry 10 --retry-delay 10 "https://discord.com/api/download?platform=linux&format=deb"
    echo "Установка discord_latest.deb в систему"
    sudo dpkg -i discord_latest.deb
    echo "Удаление временных файлов"
    rm discord_latest.deb
else
    echo "Не удалось перейти в /tmp/. Пожалуйста, выполните следующие команды вручную:"
    echo "cd /tmp/"
    echo "curl -L -o discord_latest.deb --retry 10 --retry-delay 10 \"https://discord.com/api/download?platform=linux&format=deb\""
    echo "rm discord_latest.deb"
    read -n 1 -r -p "Для продолжения нажмите enter..."
fi

