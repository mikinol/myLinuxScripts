#!/bin/sh

# Проверка на root
if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт нужно запускать с правами root (например, через sudo)"
    exit 1
fi

# Создание polkit-правила
cat << 'EOF' > /etc/polkit-1/rules.d/49-nomount-password.rules
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.udisks2.filesystem-mount") &&
        subject.isInGroup("storage")) {
        return polkit.Result.YES;
    }
});
EOF

chmod 644 /etc/polkit-1/rules.d/49-nomount-password.rules
echo "[✓] Правило polkit создано."

# Добавление пользователя в группу storage
USERNAME=$(logname)
usermod -aG storage "$USERNAME"
echo "[✓] Пользователь $USERNAME добавлен в группу storage."

echo ""
echo "Готово. Перезайди в сеанс или перезагрузи систему, чтобы изменения вступили в силу."

