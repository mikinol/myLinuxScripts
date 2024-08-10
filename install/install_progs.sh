#!/bin/bash

cd "$(dirname "$0")" || exit

echo "Перед началом установки обязательно требуется установить репозитории из install_repos.sh. Они установлены? (Д/н)"
read -r -n 1 ans

case $ans in
    [YyДд]* )
        echo "\nУстановка запускается"
        ;;
    * )
        exit
        ;;
esac

while true; do
    echo "Выберите программу для установки (введите номер или оставьте пустым для выхода):"
    echo "1. gdu и neovim 5MB -> 17MB"
    echo "2. Discord 103MB -> 260MB"
    echo "3. VsCode 103MB -> 406MB"
    echo "4. Terminator 380KB -> 2320KB"
    echo "5. Google Chrome 109MB -> 353MB"
    echo "6. Nerd Fonts для терминала 2,2GB -> (8GB) -> 2,2GB"
    read -r choice

    if [ -z "$choice" ]; then
        echo "Выход из программы."
        exit
    fi

    case $choice in
        1)
            echo "Установка gdu и neovim 5MB -> 17MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install gdu neovim
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        2)
            echo "Установка Discord 103MB -> 260MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                ./progs/discord.sh
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        3)
            echo "Установка VsCode 103MB -> 406MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install code
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        4)
            echo "Установка Terminator 380KB -> 2320KB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install terminator
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        5)
            echo "Установка Google Chrome 109MB -> 353MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install google-chrome-stable
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        6)
            echo "Установка Nerd Fonts для терминала 2,2GB -> (8GB) -> 2,2GB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                ./progs/nerd_fonts.sh
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        *)
            echo "Неправильный выбор, пожалуйста, попробуйте снова."
            ;;
    esac

    echo
done

