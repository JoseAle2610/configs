#!/bin/bash
# /home/jsuarez/dev/configs/installWorkspace.sh

# Crear enlaces simbólicos para las configuraciones
ln -sf /home/jsuarez/dev/configs/tmux.conf ~/.tmux.conf
ln -sf /home/jsuarez/dev/configs/alacritty.toml ~/.alacritty.toml
mkdir -p ~/.config/kitty
ln -sf /home/jsuarez/dev/configs/kitty.conf ~/.config/kitty/kitty.conf
ln -sf /home/jsuarez/dev/configs/opencode.json ~/.config/opencode/opencode.json

# Zed editor
mkdir -p ~/.config/zed
ln -sf /home/jsuarez/dev/configs/zed/settings.json ~/.config/zed/settings.json
ln -sf /home/jsuarez/dev/configs/zed/keymap.json ~/.config/zed/keymap.json

# IdeaVim
ln -sf /home/jsuarez/dev/configs/.ideavimrc ~/.ideavimrc

# Podés agregar otros enlaces acá según necesites
# ln -sf /home/jsuarez/dev/configs/i3config ~/.config/i3/config

echo "Enlaces simbólicos creados/actualizados."

uv tool install --with psycopg2,pymysql sqlit-tui
