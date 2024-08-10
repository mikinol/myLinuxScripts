#!/bin/bash

# Проверяем, открыт ли GNOME System Monitor
WINDOW=$(wmctrl -l | grep "Системный монитор")

if [ -z "$WINDOW" ]; then
    # Открываем GNOME System Monitor
    gnome-system-monitor -r
    echo open
else
    # Закрываем GNOME System Monitor
    echo close
    wmctrl -c "Системный монитор"
fi

