#!/bin/bash
# /home/jsuarez/dev/configs/focus.sh

DOMAINS=(
    "youtube.com"
    "www.youtube.com"
    "m.youtube.com"
    "youtube-nocookie.com"
    "shorts.com"
)

if [[ $EUID -ne 0 ]]; then
   echo "¡Ponete las pilas! Corré esto como root (sudo)."
   exit 1
fi

case "$1" in
    on)
        # Crear tabla y cadena solo si no existen
        nft add table inet focus_blocker 2>/dev/null
        nft add chain inet focus_blocker output { type filter hook output priority 0 \; } 2>/dev/null
        
        # Crear sets para IPv4 e IPv6
        nft add set inet focus_blocker youtube_ips { type ipv4_addr \; flags interval \; } 2>/dev/null
        nft add set inet focus_blocker youtube_ips_v6 { type ipv6_addr \; flags interval \; } 2>/dev/null
        
        # Limpiar sets antes de actualizar
        nft flush set inet focus_blocker youtube_ips
        nft flush set inet focus_blocker youtube_ips_v6

        echo "--- ACTUALIZANDO TABLA DE BLOQUEO (IPv4 + IPv6) ---"
        for domain in "${DOMAINS[@]}"; do
            # IPv4
            ips_v4=$(dig +short A "$domain" | grep -E '^[0-9.]+$')
            for ip in $ips_v4; do
                nft add element inet focus_blocker youtube_ips { "$ip" } 2>/dev/null
            done
            # IPv6
            ips_v6=$(dig +short AAAA "$domain" | grep -E '^[0-9a-fA-F:]+$')
            for ip in $ips_v6; do
                nft add element inet focus_blocker youtube_ips_v6 { "$ip" } 2>/dev/null
            done
        done

        # Añadir reglas solo si no existen (verificando para no duplicar)
        nft "list chain inet focus_blocker output" | grep -q "@youtube_ips " || nft add rule inet focus_blocker output ip daddr @youtube_ips drop
        nft "list chain inet focus_blocker output" | grep -q "@youtube_ips_v6 " || nft add rule inet focus_blocker output ip6 daddr @youtube_ips_v6 drop
        
        echo "Modo Stark Activo/Actualizado."
        ;;
    off)
        echo "--- DESACTIVANDO MODO STARK ---"
        nft delete table inet focus_blocker 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Bloqueo removido. Volvé a la civilización."
        else
            echo "No había ninguna tabla activa."
        fi
        ;;
    *)
        echo "Uso: sudo focus [on|off]"
        exit 1
        ;;
esac
