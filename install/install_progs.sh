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

echo "Хотите ли вы установить Discord? (Д/н)"
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

echo "Хотите ли вы установить VsCode? (Д/н)"
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


