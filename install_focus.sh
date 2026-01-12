#!/bin/bash
# /home/jsuarez/dev/configs/install_focus.sh

# dependencias (usamos --needed para no reinstalar al cuete)
sudo pacman -S --needed bind-tools nftables cronie

# habilitar y arrancar cronie (en Arch no viene por defecto)
sudo systemctl enable --now cronie

# habilitar como comando (ln -sf para que no chille si ya existe)
sudo ln -sf /home/jsuarez/dev/configs/focus.sh /usr/local/bin/focus

# Registrar en cron para actualizar IPs cada 10 minutos
# El check 'nft list table...' asegura que solo se actualice si el bloqueo está activo
CRON_JOB="*/10 * * * * nft list table inet focus_blocker >/dev/null 2>&1 && /usr/local/bin/focus on"

# Evitamos duplicados en el crontab
(sudo crontab -l 2>/dev/null | grep -v "focus on" ; echo "$CRON_JOB") | sudo crontab -

echo "Instalación completada. Comando 'focus' listo y cron configurado."
