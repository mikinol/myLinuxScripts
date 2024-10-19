#!/bin/bash

echo "Добавление ppa репозитория kdenlive"
sudo add-apt-repository ppa:kdenlive/kdenlive-stable
echo "Добавление репозитория завершено"

sudo apt update
