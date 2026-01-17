#!/bin/bash

# Script de instalación básico para Niri con DMS
# Asegúrate de tener paru instalado (AUR helper)

echo "Instalando dependencias con pacman..."
sudo pacman -Syu niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk alacritty

echo "Instalando paquetes de AUR con paru..."
paru -S dms-shell-bin matugen wl-clipboard cliphist cava qt6-multimedia-ffmpeg

echo "Agregando servicios de usuario..."
systemctl --user add-wants niri.service dms

echo "Creando directorios de configuración si no existen..."
mkdir -p ~/.config/niri

echo "Creando symlinks para configs..."
ln -sf "$(pwd)/niri/config.kdl" ~/.config/niri/config.kdl
ln -sf "$(pwd)/niri/dms" ~/.config/niri/dms

echo "Instalación completa. Reinicia la sesión o corre niri para probar."