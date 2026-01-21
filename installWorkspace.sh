#!/bin/bash
# /home/jsuarez/dev/configs/installWorkspace.sh

# Crear enlaces simbólicos para las configuraciones
ln -sf /home/jsuarez/dev/configs/tmux.conf ~/.tmux.conf
ln -sf /home/jsuarez/dev/configs/alacritty.toml ~/.alacritty.toml
mkdir -p ~/.config/kitty
ln -sf /home/jsuarez/dev/configs/kitty.conf ~/.config/kitty/kitty.conf

# Podés agregar otros enlaces acá según necesites
# ln -sf /home/jsuarez/dev/configs/i3config ~/.config/i3/config

echo "Enlaces simbólicos creados/actualizados."
