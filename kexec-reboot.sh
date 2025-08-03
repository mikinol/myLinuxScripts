#!/bin/bash
set -e

KERNEL="/boot/vmlinuz-linux"
INITRD="/boot/initramfs-linux.img"
CMDLINE="$(cat /proc/cmdline)"

echo "[*] Проверка наличия необходимых файлов..."
[ -f "$KERNEL" ] || { echo "Файл ядра не найден: $KERNEL"; exit 1; }
[ -f "$INITRD" ] || { echo "Файл initrd не найден: $INITRD"; exit 1; }

echo "[*] Загрузка нового ядра через kexec..."
sudo kexec -l "$KERNEL" \
    --initrd="$INITRD" \
    --command-line="$CMDLINE"

echo "[*] Система готова к перезагрузке. Перезапуск без BIOS/UEFI..."
sudo systemctl kexec

