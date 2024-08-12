#!/bin/bash

echo "Добавление ppa репозитория neovim"
sudo add-apt-repository ppa:neovim-ppa/unstable
echo "Добавление репозитория завершено"

sudo apt update
