#!/bin/bash

echo "Обновление списка пакетов"
sudo apt update || exit

echo "Устанавливаем Zsh..."
sudo apt install -y zsh || exit

echo "Устанавливаем Oh My Zsh..."
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh || exit

echo "Устанавливаем Zsh как оболочку по умолчанию..."
chsh -s $(which zsh) || exit

echo "Настроим тему Zsh на agnoster..."
sed -i '/^ZSH_THEME=/c\ZSH_THEME="agnoster"' ~/.zshrc || exit

echo "Установка lsd"
sudo apt install -y lsd || exit
cd ~/.oh-my-zsh/custom/plugins/ || exit
git clone https://github.com/z-shell/zsh-lsd.git || exit

echo "Настроим плагины на git tmux zsh-lsd..."
sed -i '/^plugins=(.*)/c\plugins=(git tmux zsh-lsd)' ~/.zshrc || exit

echo "Запись дополнительных данных в zshrc:"

cat <<EOL >> ~/.zshrc
export EDITOR='nvim'
alias l='ls -Alh'
alias nano='nvim'
alias weather='~/myLinuxScripts/weather.sh'
EOL
