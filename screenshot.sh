#!/bin/bash

filename="/home/mikinol/Изображения/Скриншоты/$(date +%Y-%m-%d_%H-%M-%S).png"
gnome-screenshot -a -c -f "$filename"
