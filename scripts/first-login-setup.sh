#!/bin/bash
# Eseguito una volta al primo login utente tramite systemd user service

set -euo pipefail

SCRIPT_DIR=/usr/share/fedora-hyprland-remix

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
while IFS= read -r app; do
    flatpak install --user --noninteractive flathub "$app"
done < "${SCRIPT_DIR}/flatpak-apps.txt"

# Flatpak theming — accesso a temi e icone di sistema
flatpak override --user --filesystem=/usr/share/themes:ro
flatpak override --user --filesystem=/usr/share/icons:ro
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

# GTK theme via gsettings (per flatpak su desktop non-GNOME)
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'catppuccin-mocha-dark-cursors'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# VSCode extensions
while IFS= read -r ext; do
    code --install-extension "$ext"
done < "${SCRIPT_DIR}/vscode-extensions.txt"

# Developer tools
curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://mise.run | sh
curl -fsSL https://opencode.ai/install | sh
~/.local/bin/mise use --global ansible glab

notify-send "Fedora Hyprland Remix" "Configurazione Terminata" --icon=system-software-install
