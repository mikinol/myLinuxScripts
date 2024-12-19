#!/bin/bash

# Путь к скрипту, который должен быть выполнен
SCRIPT_PATH="/home/mikinol/mylinuxScripts/vpn-ignore.sh"
SERVICE_PATH="/etc/systemd/system/vpn-ignore.service"

# Создание systemd сервиса
echo "Создание systemd сервиса..."

sudo tee $SERVICE_PATH > /dev/null <<EOL
[Unit]
Description=VPN Ignore Script
After=network.target

[Service]
Type=simple
ExecStart=$SCRIPT_PATH
User=root
Group=root
Restart=always
RestartSec=1h

[Install]
WantedBy=multi-user.target
EOL

echo "Перезагрузка systemd и активация службы..."
sudo systemctl daemon-reload
sudo systemctl enable vpn-ignore.service
sudo systemctl start vpn-ignore.service

echo "Сервис vpn-ignore установлен и запущен."
