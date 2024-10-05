#!/bin/bash

echo "Добавление flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Добавление GNOME Nightly"
flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo

echo "Добавление Elementary OS Applications"
flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo

