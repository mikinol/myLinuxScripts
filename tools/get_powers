#!/usr/bin/env python3
import time

path = "/sys/class/powercap/intel-rapl:0/energy_uj"

def read_energy():
    with open(path, "r") as f:
        return int(f.read().strip())  # микроджоули

def start_reading_energy(start):
    end = read_energy()

    # Если счётчик переполнился (он циклический), учитываем
    if end < start:
        # На Intel обычно 32-битный счётчик, максимум ~2^32 мкДж
        max_val = 2**32
        used = (end + max_val - start)
        print("Переполнение")
    else:
        used = end - start

    power_watts = used / 1e6  # перевод в джоули (за 1 сек) = ватты
    print(f"Power: {power_watts:.2f} W", end="\r")
    return end


# Считаем за интервал 1 секунда
start = read_energy()
try:
    while True:
        time.sleep(1)
        start = start_reading_energy(start)
except KeyboardInterrupt:
    exit(0)
