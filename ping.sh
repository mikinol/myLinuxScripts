#!/bin/bash

# Настройки
DELAY_MS=500  # Задержка в миллисекундах
IFACE="wlp2s0"  # Основной интерфейс

# Функция для очистки при выходе
cleanup() {
    echo "Очищаю правила iptables и tc..."
    iptables -D OUTPUT -o "$IFACE" -p tcp --dport 25565 -j MARK --set-mark 1 2>/dev/null
    tc qdisc del dev "$IFACE" root 2>/dev/null
    exit 0
}

# Устанавливаем обработчик выхода
trap cleanup INT

# Добавляем правило iptables для маркировки пакетов на порт 25565
iptables -A OUTPUT -o "$IFACE" -p tcp --dport 25565 -j MARK --set-mark 1

# Добавляем задержку через tc (Traffic Control) для основного интерфейса
tc qdisc add dev "$IFACE" root handle 1: prio
tc qdisc add dev "$IFACE" parent 1:1 handle 10: netem delay ${DELAY_MS}ms

echo "Добавлена задержка в ${DELAY_MS} мс для пакетов на порт 25565 через $IFACE"
echo "Нажмите Ctrl+C для отключения"

# Бесконечный цикл
while true; do
    sleep 1
done

