#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен с правами суперпользователя (sudo)." 
   exit 1
fi

apt install devilspie2

USER="mikinol"  # Замените на ваше имя пользователя
DEVILSPIE2_PATH="/usr/bin/devilspie2"
DISCORD_PATH="/usr/bin/discord"

mkdir -p ~/.config/devilspie2/

cat << EOF > ~/.config/devilspie2/discord.lua
debug_print("Window name: " .. get_window_name());
debug_print("Application name: " .. get_application_name())
if (string.match(get_window_name(), " - Discord$")) then
    debug_print("discord")
    close_window()
end
EOF

cat << EOF > /etc/systemd/system/devilspie2.service
[Unit]
Description=Start Devilspie2

[Service]
ExecStart=${DEVILSPIE2_PATH}
Restart=always
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/${USER}/.Xauthority
User=${USER}

[Install]
WantedBy=default.target
EOF

cat << EOF > /etc/systemd/system/discord.service
[Unit]
Description=Discord Application
After=devilspie2.service

[Service]
ExecStart=${DISCORD_PATH}
Restart=always
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/${USER}/.Xauthority
User=${USER}

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable devilspie2.service
systemctl enable discord.service

systemctl start devilspie2.service
systemctl start discord.service

echo "Devilspie2 и Discord успешно настроены для автозагрузки."
