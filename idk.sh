#!/bin/bash

LED_PATH="/sys/class/leds/input18::capslock/brightness"

if [ ! -w "$LED_PATH" ]; then
    echo "Нет доступа к $LED_PATH. Запусти скрипт с правами root."
    exit 1
fi

TIMINGS=(0.2 0.5 0.1 0.3 0.4)

for delay in "${TIMINGS[@]}"; do
    echo 1 > "$LED_PATH"
    sleep 0.1   # чтобы ядро точно увидело включение
    echo 0 > "$LED_PATH"  # вручную выключаем
    sleep "$delay"
done


