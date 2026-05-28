# Fedora Hyprland Remix

Fedora 44 Live ISO con **Hyprland** come window manager, configurata per lo sviluppo.

Non e una Fedora Spin ufficiale — e una **remix** non ufficiale basata su Fedora.

## Stack

| Componente | Tool |
|---|---|
| Window Manager | [Hyprland](https://hyprland.org/) |
| Status Bar | [Waybar](https://github.com/Alexays/Waybar) |
| Terminale | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| Launcher | [Wofi](https://hg.sr.ht/~scoopta/wofi) |
| Notifiche | [Mako](https://github.com/emersion/mako) |
| Lock Screen | [Hyprlock](https://github.com/hyprwm/hyprlock) |
| Display Manager | [SDDM](https://github.com/sddm/sddm) |
| Tema GTK | Catppuccin Mocha Blue |
| Icone | Papirus-Dark (Catppuccin) |
| Cursori | Catppuccin Mocha Dark |

## Cosa e incluso

- **Browser**: Brave, LibreWolf, Google Chrome
- **App**: Telegram, Thunderbird, Spotify, Bruno, VLC, LibreOffice, OBS
- **Sviluppo**: VS Code, Podman (rootless), Ansible, glab, Neovim, Git
- **Desktop**: Thunar, Kitty, Waybar, Wofi, Mako, Hyprlock, Hypridle

## Requisiti build locale

- Fedora 44 (o compatibile)
- Root
- Pacchetti: `lorax`, `pykickstart`

```bash
sudo dnf install -y lorax pykickstart
```

## Build locale

```bash
# Build Live ISO
sudo bash build.sh

# Oppure con just
sudo just build-iso

# Build per una versione specifica
sudo FEDORA_RELEASE=44 just build-iso
```

L'ISO viene salvata in `output/`.

## Struttura

```
fedora-hyprland-remix/
├── fedora-hyprland.ks          # Kickstart — cuore della remix
├── config/                     # Dotfiles → copiati in /etc/skel
│   ├── common/                 # Config comuni (bash, kitty, gtk, ecc.)
│   └── hyprland/               # Config Hyprland (hyprland.conf, waybar, ecc.)
├── scripts/
│   ├── first-login-setup.sh    # Setup primo login (flatpak, vscode, dev tools)
│   ├── flatpak-apps.txt        # Lista app Flatpak
│   └── vscode-extensions.txt   # Lista estensioni VS Code
├── units/
│   └── first-login-setup.service  # Systemd user service per primo login
├── build.sh                    # Script build ISO
├── Justfile                    # Task runner
└── .github/workflows/
    └── build-iso.yml           # CI/CD per build automatico
```

## Hyprland COPR

Hyprland non e nei repo ufficiali Fedora (dopo F42). Questa remix usa il COPR
[sdegler/hyprland](https://copr.fedorainfracloud.org/coprs/sdegler/hyprland/) che fornisce
Hyprland 0.55.x per Fedora 44.

## Licenza

Apache 2.0
