#!/bin/sh

set -e

HOOK_FILE="/etc/pacman.d/hooks/10-vencord.hook"

echo "Устанавливаем vencord-installer через paru..."
paru -S --noconfirm vencord-installer

sudo /usr/bin/vencordinstallercli -install -location /opt/discord

echo "Создаем директорию для pacman hook, если нужно..."
sudo mkdir -p /etc/pacman.d/hooks/

echo "Создаем pacman hook для автоматического патчинга Discord..."
sudo tee /etc/pacman.d/hooks/10-vencord.hook >/dev/null <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = discord

[Action]
Description = Patching Discord
Depends = vencord-installer
When = PostTransaction
Exec = /usr/bin/vencordinstallercli -repair -location /opt/discord
EOF

echo "Готово! Pacman hook создан: $HOOK_FILE"
echo "Теперь при обновлении Discord Vencord будет автоматически восстанавливаться."

