#!/bin/bash

echo "Добавление ppa репозитория fastfetch"
sudo add-apt-repository ppa:kdenlive/kdenlive-stable
echo "Добавление репозитория завершено"

sudo apt update
