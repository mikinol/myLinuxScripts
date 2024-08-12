#!/bin/bash

echo "Добавление ppa репозитория terminator"
sudo add-apt-repository ppa:mattrose/terminator
echo "Добавление репозитория завершено"

sudo apt update
