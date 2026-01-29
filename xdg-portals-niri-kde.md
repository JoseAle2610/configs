# XDG Desktop Portals en niri (wlroots) + KDE/Plasma — notas de este quilombo

## Síntomas

- **Abrir/Guardar** (file chooser) a veces salía “como Dolphin” y a veces otro diálogo.
- **Abrir carpeta / mostrar en carpeta** abría un file manager distinto (dependía de `inode/directory`).
- **Meet (Firefox) screen share** dejó de funcionar o cambió el selector (solo pantalla completa).
- En **KDE/Plasma**, después de tocar portals para niri, dejó de funcionar compartir pantalla.

## Conceptos (sin humo)

- **Abrir/Guardar archivo** en Wayland normalmente es **XDG Desktop Portal (FileChooser)**, no “un file manager”.
- **Abrir una carpeta** es otra cosa: es el handler MIME de `inode/directory` (ej: Dolphin, Nautilus, etc.).
- **Compartir pantalla** en Wayland (Meet/Zoom/etc.) usa **PipeWire + xdg-desktop-portal** (interfaces `ScreenCast`/`RemoteDesktop`).
- En **wlroots** (niri), el backend típico para screencast es **`xdg-desktop-portal-wlr`**.
- En **Plasma**, el backend esperado es **`xdg-desktop-portal-kde`**.

## Dato clave: configuración por escritorio

No uses `~/.config/xdg-desktop-portal/portals.conf` global si tenés **más de un escritorio**.

Usá archivos por desktop (según `XDG_CURRENT_DESKTOP`):

- `~/.config/xdg-desktop-portal/kde-portals.conf`
- `~/.config/xdg-desktop-portal/niri-portals.conf`

Esto evita que lo que arregla niri te rompa KDE, y viceversa.

La doc oficial lo explica: `portals.conf(5)` busca primero configs específicas como `kde-portals.conf`, y recién después un `portals.conf` genérico.

## Solución en KDE/Plasma (para screen share y portales)

**Objetivo:** que en KDE el portal sea KDE (y no “fallback a gtk”).

Crear:

```bash
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/kde-portals.conf <<'EOF'
[preferred]
default=kde
EOF

systemctl --user restart xdg-desktop-portal
```

Notas:

- Es normal que `xdg-desktop-portal-kde.service` “no exista”: muchas veces el backend KDE es **activable por D-Bus**.
- Si ves en logs algo como `Choosing gtk.portal ... last-resort fallback`, es que no está usando KDE como backend.

Comandos útiles para ver qué pasa:

```bash
journalctl --user -u xdg-desktop-portal -b | rg -i 'fallback|Choosing gtk\.portal'
busctl --user list | rg -n 'org\.freedesktop\.impl\.portal\.desktop\.(kde|gtk|gnome)'
eza -la /usr/share/xdg-desktop-portal | rg -n 'kde|gtk|gnome|portals\.conf'
```

## Solución en niri (wlroots) para screen share

**Objetivo:** que Meet funcione en Wayland usando `wlr` para screencast.

Instalar:

```bash
sudo pacman -S xdg-desktop-portal-wlr
```

Config específica para niri:

```bash
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/niri-portals.conf <<'EOF'
[preferred]
default=gtk
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.RemoteDesktop=wlr
EOF

systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gtk
```

Si además querés FileChooser KDE en niri (opcional):

```ini
org.freedesktop.impl.portal.FileChooser=kde
org.freedesktop.impl.portal.Settings=gtk
```

## Dolphin siempre como file manager (abrir carpetas)

Esto NO afecta el diálogo Abrir/Guardar. Solo el “abrir carpeta”.

```bash
xdg-mime default org.kde.dolphin.desktop inode/directory
xdg-mime default org.kde.dolphin.desktop inode/mount-point
```

Para volver a como estaba (ej: `kitty-open.desktop`):

```bash
xdg-mime default kitty-open.desktop inode/directory
xdg-mime default kitty-open.desktop inode/mount-point
```

## Por qué cambió el selector (solo pantalla completa)

Cuando Firefox está en **Wayland** (`about:support` → “Protocolo de ventanas: wayland”), el screen share pasa por portal/pipewire.
Con `wlr` y ciertos compositores/backends, el picker puede ofrecer **solo monitor** (y no ventanas/pestañas).

Workaround para probar “como antes”:

```bash
MOZ_ENABLE_WAYLAND=0 firefox
```

Eso fuerza XWayland/X11 path (a veces devuelve picker de ventanas distinto). Tradeoff: perdés beneficios de Wayland.

## Revert (hard/soft)

### Soft (recomendado):

- Borrar/mover configs de portal y reiniciar portales.

```bash
mv ~/.config/xdg-desktop-portal/portals.conf ~/.config/xdg-desktop-portal/portals.conf.bak
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-gtk
```

### Hard (desinstalar lo agregado)

Antes mirá dependencias:

```bash
pacman -Qi xdg-desktop-portal-wlr xdg-desktop-portal-kde qt6ct kvantum kvantum-qt5 | rg -n '^(Name|Required By|Depends On)'
sudo pacman -Rns --print xdg-desktop-portal-wlr xdg-desktop-portal-kde qt6ct kvantum kvantum-qt5
```

Después:

```bash
sudo pacman -Rns xdg-desktop-portal-wlr xdg-desktop-portal-kde qt6ct kvantum kvantum-qt5
```

## Checklist rápido

- KDE:
  - `XDG_CURRENT_DESKTOP=KDE`
  - `~/.config/xdg-desktop-portal/kde-portals.conf` existe
  - `busctl --user list` muestra `org.freedesktop.impl.portal.desktop.kde`
- niri:
  - `XDG_CURRENT_DESKTOP=niri`
  - `~/.config/xdg-desktop-portal/niri-portals.conf` existe
  - instalado `xdg-desktop-portal-wlr`
