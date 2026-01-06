#/bin/bash

# dependencias
sudo pacman -S bind-tools nftables

# habilitar como comando
sudo ln -s /home/jsuarez/dev/configs/focus.sh /usr/local/bin/focus
