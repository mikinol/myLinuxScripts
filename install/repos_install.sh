#!/bin/bash

cd "$(dirname "$0")" || exit

./repos/nvim_ppa.sh

./repos/terminator_ppa.sh

./repos/vscode.sh

./repos/chrome.sh

./repos/jetbrains.sh

./repos/fastfetch_ppa.sh

./repos/newflatpak.sh
