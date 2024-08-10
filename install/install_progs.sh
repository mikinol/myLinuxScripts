#!/bin/bash

cd "$(dirname "$0")" || exit

echo "Хотите ли вы установить Discord? (Д/Н)"
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
