#!/bin/bash

HOST=${1:-pc.lan}

echo "⏳ Проверка доступности $HOST..."

# Первый ping с захватом TTL
PING_OUTPUT=$(ping -c 1 -W 1 "$HOST")

# Проверка, был ли ответ
if ! echo "$PING_OUTPUT" | grep -q "ttl="; then
    echo "⚠️ Первый пакет потерян, пробуем ещё раз..."
    PING_OUTPUT=$(ping -c 1 -W 1 "$HOST")
    
    if ! echo "$PING_OUTPUT" | grep -q "ttl="; then
        echo "❌ Хост $HOST недоступен или блокирует ICMP"
        exit 1
    fi
fi

# Извлекаем TTL
TTL=$(echo "$PING_OUTPUT" | grep "ttl=" | sed -E 's/.*ttl=([0-9]+).*/\1/')

# Определение ОС по TTL
if [[ $TTL -ge 128 ]]; then
    echo "✅ Хост отвечает, TTL=$TTL → вероятно Windows"
elif [[ $TTL -ge 64 ]]; then
    echo "✅ Хост отвечает, TTL=$TTL → вероятно Linux/Unix"
elif [[ $TTL -ge 32 ]]; then
    echo "✅ Хост отвечает, TTL=$TTL → возможно старый Unix/RouterOS"
else
    echo "✅ Хост отвечает, TTL=$TTL → неизвестная ОС"
fi
