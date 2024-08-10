#!/bin/bash

cd /tmp/ || exit
git clone --depth 1 --progress --branch master --single-branch https://github.com/ryanoasis/nerd-fonts.git
echo "nerd-fonts клонирован"
echo "Нажмите любую клавишу для продолжения..."
read -r -n 1
echo "Установка nerd-fonts"
./nerd-fonts/install.sh
echo "nerd-fonts установлен, очистка временных файлов"
rm -rf ./nerd-fonts
