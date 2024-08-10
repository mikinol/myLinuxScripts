#!/bin/bash

PID_FILE="/tmp/mouse_clicker.pid"
DEFAULT_INTERVAL=0.5
DEFAULT_BUTTON=1

# Функция для отображения справки
show_help() {
    echo "Usage: $0 [-t interval] [-b button]"
    echo ""
    echo "Options:"
    echo "  -t INTERVAL    Time interval between clicks (default: $DEFAULT_INTERVAL seconds)"
    echo "  -b BUTTON      Mouse button to click (default: $DEFAULT_BUTTON)"
    echo "  --help         Show this help message"
}

# Парсинг аргументов
while getopts "t:b:-:" opt; do
    case $opt in
        t) INTERVAL=$OPTARG ;;
        b) BUTTON=$OPTARG ;;
        -)
            case $OPTARG in
                help)
                    show_help
                    exit 0
                    ;;
                *)
                    echo "Unknown option --$OPTARG"
                    show_help
                    exit 1
                    ;;
            esac
            ;;
        \?)
            show_help
            exit 1
            ;;
    esac
done

# Установка значений по умолчанию, если они не были заданы
INTERVAL=${INTERVAL:-$DEFAULT_INTERVAL}
BUTTON=${BUTTON:-$DEFAULT_BUTTON}

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm -f "$PID_FILE"
        notify-send "Mouse Clicker" "Кликер выключен"
        exit 0
    fi
fi

# Запуск кликера в фоновом режиме
(
    notify-send "Mouse Clicker" "Кликер включен: интервал=${INTERVAL}с, кнопка=${BUTTON}"
    while true; do
        xdotool click "$BUTTON"
        sleep "$INTERVAL"
    done
) &

# Сохранение PID фонового процесса
echo $! > "$PID_FILE"

