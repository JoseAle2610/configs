#!/bin/bash
# Dominios a banear (la perdición de tu productividad)
DOMAINS=(
    "youtube.com"
    "www.youtube.com"
    "m.youtube.com"
    "googlevideo.com"
    "ytimg.com"
    "s.ytimg.com"
    "youtube-nocookie.com"
)
if [[ $EUID -ne 0 ]]; then
   echo "¡Ponete las pilas! Corré esto como root (sudo)."
   exit 1
fi
case "$1" in
    on)
        echo "--- ACTIVANDO MODO STARK (Deep Work) ---"
        # Crear tabla y cadena
        nft add table inet focus_blocker
        nft add chain inet focus_blocker output { type filter hook output priority 0 \; }
        # Crear el set de IPs
        nft add set inet focus_blocker youtube_ips { type ipv4_addr \; flags interval \; }
        echo "Resolviendo dominios y bloqueando..."
        for domain in "${DOMAINS[@]}"; do
            # Obtenemos todas las IPs del dominio
            ips=$(dig +short "$domain" | grep -E '^[0-9.]+$')
            for ip in $ips; do
                nft add element inet focus_blocker youtube_ips { "$ip" }
                echo "Bloqueado: $domain -> $ip"
            done
        done
        # Regla final: todo lo que vaya a esas IPs se muere
        nft add rule inet focus_blocker output ip daddr @youtube_ips drop
        echo "----------------------------------------"
        echo "YouTube ha muerto. ¡PONETE A LABURAR!"
        ;;
    off)
        echo "--- DESACTIVANDO MODO STARK ---"
        nft delete table inet focus_blocker 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Bloqueo removido. No te pases con los videos de gatitos."
        else
            echo "No había ninguna tabla de bloqueo activa."
        fi
        ;;
    *)
        echo "Uso: sudo ./focus.sh [on|off]"
        exit 1
        ;;
esac
