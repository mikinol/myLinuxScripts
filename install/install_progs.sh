#!/bin/bash

cd "$(dirname "$0")" || exit
while true; do
    echo "Выберите программу для установки (введите номер или оставьте пустым для выхода):"
    echo "1. gdu и neovim 5MB -> 17MB"
    echo "2. Discord 103MB -> 260MB"
    echo "3. VsCode 103MB -> 406MB"
    echo "4. Terminator 380KB -> 2320KB"
    echo "5. Google Chrome 109MB -> 353MB"
    echo "6. Nerd Fonts для терминала 2,2GB -> (8GB) -> 2,2GB"
    echo "7. Steam 100MB"
    echo "8. Очень важное говно 2MB"
    echo "9. Element X 99MB -> 372MB"
    echo "10. Java (8,17,21)"
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
                ./repos/nvim_ppa.sh
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
                ./repos/vscode.sh
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
                ./repos/terminator_ppa.sh
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
                ./repos/chrome.sh
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
        7)
            echo "Установка Steam 100MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                ./progs/steam.sh
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        8)
            echo "Установка очень важного говна на 2MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install font-manager
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        9)
            echo "Установка Element X 99MB -> 372MB. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                sudo apt install -y wget apt-transport-https
                sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list

                sudo apt update

                sudo apt install element-desktop
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        10)
            echo "10. Java (8,17,21). Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                ./progs/java.sh
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        11)
            echo "11. Fastfetch. Вы уверены? (Д/н)"
            read -r -n 1 ans
            if [[ $ans =~ [YyДд]* ]]; then
                ./repos/fastfetch_ppa.sh
                echo "Удаление сушествуюшего neofetch"
                sudo apt remove neofetch
                echo "Установка fastfetch"
                sudo apt install fastfetch
                echo "Установка завершена."
            else
                echo "Установка отменена."
            fi
            ;;
        *)sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
            echo "Неправильный выбор, пожалуйста, попробуйте снова."
            ;;
    esac

    echo
done

