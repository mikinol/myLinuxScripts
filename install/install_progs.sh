#!/bin/bash

cd "$(dirname "$0")" || exit

echo "Перед началом установки обязательно требуется установить репозитории из install_repos.sh. Они установленны? (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка запускается"
        ;;
    * )
        exit
        ;;
esac

echo "Установка gdu и neovim 5MB -> 17MB"
sudo apt install gdu neovim

echo "Хотите ли вы установить Discord? 103MB -> 260MB (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка Discord начинается."
        ./progs/discord.sh
        ;;
    * )
        echo "Установка Discord отменена, вы всё ещё можете установить Discord выполнив $(dirname "$0")/progs/discord.sh"
        ;;
esac

echo "Хотите ли вы установить VsCode? 103MB -> 406MB (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка VsCode начинается."
        sudo apt install code
        ;;
    * )
        echo "Установка VsCode отменена, вы всё ещё можете установить VsCode выполнив \"sudo apt install code\""
        ;;
esac

echo "Хотите ли вы установить терминал Terminator? 380KB -> 2320KB (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка Terminator начинается."
        sudo apt install terminator
        ;;
    * )
        echo "Установка Terminator отменена, вы всё ещё можете установить Terminator выполнив \"sudo apt install terminator\""
        ;;
esac

echo "Хотите ли вы установить Google Chrome? 109MB -> 353MB (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка Google Chrome начинается."
        sudo apt install google-chrome-stable
        ;;
    * )
        echo "Установка Google Chrome отменена, вы всё ещё можете установить Google Chrome выполнив \"sudo apt install google-chrome-stable\""
        ;;
esac

echo "Хотите ли вы установить Nerd Fonts для терминала? 2,2GB -> (8GB) -> 2,2GB (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "Установка Nerd Fonts начинается."
        ./progs/nerd_fonts.sh
        ;;
    * )
        echo "Установка Nerd Fonts отменена, вы всё ещё можете установить Nerd Fonts выполнив \"$(dirname "$0")/progs/nerd_fonts.sh\""
        ;;
esac
