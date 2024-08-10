#!/bin/bash

echo "Установка Discord"
if cd /tmp/; then
    echo "Скачивание steam_latest.deb"
    curl -L -o steam_latest.deb --retry 10 --retry-delay 10 "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"
    echo "Установка steam_latest.deb в систему"
    sudo dpkg -i steam_latest.deb
    echo "Удаление временных файлов"
    rm steam_latest.deb
else
    echo "Не удалось перейти в /tmp/. Пожалуйста, выполните следующие команды вручную:"
    echo "cd /tmp/"
    echo "curl -L -o steam_latest.deb --retry 10 --retry-delay 10 \"https://cdn.akamai.steamstatic.com/client/installer/steam.deb\""
    echo "rm steam_latest.deb"
    read -n 1 -r -p "Для продолжения нажмите enter..."
fi

