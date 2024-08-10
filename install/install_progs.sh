#!/bin/bash

cd "$(dirname "$0")" || exit

echo "Хотите ли вы установить Discord? (Д/н)"
read -r ans

case $ans in
    [YyДд]* )
        echo "Установка Discord начинается."
        ./progs/discord.sh
        ;;
    * )
        echo "Установка Discord отменена, вы всё ещё можете установить Discord выполнив $(dirname "$0")/progs/discord.sh"
        ;;
esac

echo "Хотите ли вы установить VsCode (Требуются установленные репозитории из install_repos.sh)? (Д/н)"
read -r ans

case $ans in
    [YyДд]* )
        echo "Установка VsCode начинается."
        sudo apt install code
        ;;
    * )
        echo "Установка Discord отменена, вы всё ещё можете установить Discord выполнив \"sudo apt install code\""
        ;;
esac
