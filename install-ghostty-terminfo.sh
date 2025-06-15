#!/bin/bash

# === Проверка аргумента ===
if [[ -z "$1" ]]; then
  echo "Использование: $0 user@host"
  exit 1
fi

REMOTE="$1"
REMOTE_TMP="/tmp/ghostty.terminfo"

# === Создание terminfo-файла ===
echo "[*] Генерация ghostty terminfo..."
infocmp xterm-ghostty > /tmp/ghostty.terminfo || {
  echo "❌ Не удалось получить описание terminfo!"
  exit 1
}

# === Копирование на сервер ===
echo "[*] Копирую на сервер..."
scp /tmp/ghostty.terminfo "$REMOTE:$REMOTE_TMP" || {
  echo "❌ SCP не удался!"
  exit 1
}

# === Установка на сервере ===
echo "[*] Установка на сервере..."
ssh "$REMOTE" "tic -x $REMOTE_TMP && rm -f $REMOTE_TMP" || {
  echo "❌ Установка через tic не удалась!"
  exit 1
}

echo "✅ Готово! Terminfo для ghostty установлен на $REMOTE"
