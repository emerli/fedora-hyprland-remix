#!/bin/bash
# Lancia wofi con l'ambiente corretto dal systemd user manager.
# Risolve il problema per cui polkit non trova l'agente quando le app
# vengono lanciate da wofi su Hyprland.

while IFS= read -r line; do
    case "$line" in
        DBUS_SESSION_BUS_ADDRESS=*|\
        XDG_SESSION_TYPE=*|\
        XDG_RUNTIME_DIR=*|\
        WAYLAND_DISPLAY=*|\
        DISPLAY=*)
            export "$line"
            ;;
    esac
done < <(systemctl --user show-environment)

exec wofi "$@"
