#!/bin/bash
# Abilita solo il monitor esterno quando è connesso, altrimenti usa il portatile

LAPTOP="eDP-1"

switch_monitors() {
    if hyprctl monitors | grep "^Monitor" | grep -qv "$LAPTOP"; then
        hyprctl keyword monitor "$LAPTOP,disabled"
    else
        hyprctl keyword monitor "$LAPTOP,preferred,auto,auto"
    fi
}

handle() {
    case $1 in
        monitoradded*|monitorremoved*)
            sleep 0.5
            switch_monitors
            ;;
    esac
}

# Gestisci lo stato iniziale all'avvio
switch_monitors

# Ascolta gli eventi di Hyprland
socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do
        handle "$line"
    done
