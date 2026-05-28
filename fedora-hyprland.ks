# Fedora Hyprland Remix — Live ISO Kickstart
# Base: Fedora 44 | WM: Hyprland 0.55.x (COPR sdegler/hyprland)
# Build: livecd-creator --config fedora-hyprland.ks --fslabel Fedora-Hyprland-Remix --cache /var/cache/live

lang it_IT.UTF-8
keyboard it
timezone Europe/Rome --isUtc

# ── Repositories ──────────────────────────────────────────────────────────────
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-44&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f44&arch=x86_64
repo --name=rpmfusion-free --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-44&arch=x86_64
repo --name=rpmfusion-nonfree --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-44&arch=x86_64
repo --name=hyprland --baseurl=https://download.copr.fedorainfracloud.org/results/sdegler/hyprland/fedora-44-x86_64/

# ── Packages ──────────────────────────────────────────────────────────────────
%packages
@core
@standard

# ── Live environment ──────────────────────────────────────────────────────────
@livecd-tools
anaconda-dracut
dracut-config-generic
kernel
grub2-efi-x64
grub2-efi-x64-modules
shim-x64
efibootmgr
syslinux
memtest86+
plymouth
plymouth-theme-spinner

# ── Desktop: Hyprland ─────────────────────────────────────────────────────────
hyprland
hyprland-guiutils
hyprland-qt-support
hyprpaper
hyprlock
hypridle
xdg-desktop-portal-hyprland
hyprpolkitagent

# ── Desktop: Core ─────────────────────────────────────────────────────────────
sddm
mate-polkit
swaylock
waybar
wofi
kitty
pavucontrol
network-manager-applet
nm-connection-editor
blueman
wlogout
brightnessctl
playerctl
mako
grim
grimshot
slurp
kanshi
wlr-randr
wlsunset
xdg-user-dirs
xsettingsd
gvfs
gvfs-client
gvfs-mtp
gvfs-smb
gvfs-gphoto2

# ── Apps ──────────────────────────────────────────────────────────────────────
thunar
mousepad
thunar-archive-plugin
thunar-volman
tumbler
xarchiver
catfish
gigolo
ristretto
evince
foliate
system-config-printer

# ── Network & Security ────────────────────────────────────────────────────────
openconnect
NetworkManager-openconnect
NetworkManager-openconnect-gnome
fprintd
fprintd-pam
mobile-broadband-provider-info
bolt
pinentry-gnome3
gnome-keyring
gnome-keyring-pam

# ── System ────────────────────────────────────────────────────────────────────
tuned
tuned-ppd
tuned-switcher
git
neovim
p7zip
meld
ripgrep
inotify-tools
wev
hdparm
plocate

# ── Fonts (pacchetti repo) ────────────────────────────────────────────────────
fontawesome-6-brands-fonts
fontawesome-6-free-fonts
jetbrains-mono-fonts-all

# ── Multimedia ────────────────────────────────────────────────────────────────
gstreamer1-plugin-openh264
lame
intel-media-driver

# ── Containers ────────────────────────────────────────────────────────────────
podman-compose

# ── Themes (pacchetti repo) ───────────────────────────────────────────────────
papirus-icon-theme
%end

# ── Post-install ──────────────────────────────────────────────────────────────
%post --log=/root/ks-post.log
set -euo pipefail

# ── Google Chrome repo ────────────────────────────────────────────────────────
rpm --import https://dl.google.com/linux/linux_signing_key.pub
cat > /etc/yum.repos.d/google-chrome.repo << 'CHROME'
[google-chrome]
name=Google Chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
CHROME
dnf -y install google-chrome-stable

# ── VS Code repo ──────────────────────────────────────────────────────────────
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat > /etc/yum.repos.d/vscode.repo << 'VSCODE'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
VSCODE
dnf -y install code

# ── Intel media driver swap ───────────────────────────────────────────────────
dnf -y swap libva-intel-media-driver intel-media-driver --allowerasing || true

# ── Nerd Font (JetBrainsMono) ─────────────────────────────────────────────────
NERD_FONT_VERSION="3.3.0"
curl -fLo /tmp/JetBrainsMono.tar.xz \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}/JetBrainsMono.tar.xz"
mkdir -p /usr/share/fonts/JetBrainsMonoNF
tar -xf /tmp/JetBrainsMono.tar.xz -C /usr/share/fonts/JetBrainsMonoNF
rm -f /tmp/JetBrainsMono.tar.xz
fc-cache -fv

# ── Catppuccin GTK theme ──────────────────────────────────────────────────────
CATPPUCCIN_GTK_TAG="v1.0.3"
CATPPUCCIN_GTK_NAME="catppuccin-mocha-blue-standard+default"
curl -fLo /tmp/catppuccin-gtk.zip \
    "https://github.com/catppuccin/gtk/releases/download/${CATPPUCCIN_GTK_TAG}/${CATPPUCCIN_GTK_NAME}.zip"
mkdir -p /usr/share/themes
unzip -o /tmp/catppuccin-gtk.zip -d /usr/share/themes/
rm -f /tmp/catppuccin-gtk.zip

# ── Catppuccin cursors ────────────────────────────────────────────────────────
CATPPUCCIN_CURSORS_TAG="v2.0.0"
CATPPUCCIN_CURSORS_NAME="catppuccin-mocha-dark-cursors"
curl -fLo /tmp/catppuccin-cursors.zip \
    "https://github.com/catppuccin/cursors/releases/download/${CATPPUCCIN_CURSORS_TAG}/${CATPPUCCIN_CURSORS_NAME}.zip"
unzip -o /tmp/catppuccin-cursors.zip -d /usr/share/icons/
rm -f /tmp/catppuccin-cursors.zip

# ── Papirus folders: Catppuccin Mocha Blue ────────────────────────────────────
curl -fLo /tmp/papirus-folders \
    "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/refs/heads/master/papirus-folders"
chmod +x /tmp/papirus-folders
/tmp/papirus-folders --theme Papirus-Dark --color blue
rm -f /tmp/papirus-folders

# ── Copy dotfiles to /etc/skel ────────────────────────────────────────────────
mkdir -p /etc/skel/.config
mkdir -p /etc/skel/.local/bin
mkdir -p /etc/skel/.local/share/wallpapers

# bash config
cat > /etc/skel/.bashrc << 'BASHRC'
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='[\u@\h \W]\$ '

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
BASHRC

cat > /etc/skel/.bash_profile << 'BASHPROFILE'
# ~/.bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
BASHPROFILE

cat > /etc/skel/.bash_aliases << 'BASHALIAS'
# Custom aliases
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
BASHALIAS

cat > /etc/skel/.nanorc << 'NANORC'
set linenumbers
set tabsize 4
set autoindent
NANORC

# ── Create liveuser ──────────────────────────────────────────────────────────
useradd -m -c "Live User" -s /bin/bash liveuser
echo "liveuser:liveuser" | chpasswd
usermod -aG wheel liveuser

# ── SDDM autologin ───────────────────────────────────────────────────────────
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/autologin.conf << 'SDDM'
[Autologin]
User=liveuser
Session=hyprland.desktop
Relogin=true
SDDM

# ── Enable services ──────────────────────────────────────────────────────────
systemctl enable sddm.service
systemctl set-default graphical.target
systemctl enable podman.socket
systemctl enable fstrim.timer
systemctl enable firewalld

# ── First-login setup script ─────────────────────────────────────────────────
mkdir -p /usr/share/fedora-hyprland-remix

cat > /usr/bin/first-login-setup.sh << 'FIRSTLOGIN'
#!/bin/bash
set -euo pipefail

SCRIPT_DIR=/usr/share/fedora-hyprland-remix

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
while IFS= read -r app; do
    flatpak install --user --noninteractive flathub "$app"
done < "${SCRIPT_DIR}/flatpak-apps.txt"

flatpak override --user --filesystem=/usr/share/themes:ro
flatpak override --user --filesystem=/usr/share/icons:ro
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'catppuccin-mocha-dark-cursors'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

while IFS= read -r ext; do
    code --install-extension "$ext"
done < "${SCRIPT_DIR}/vscode-extensions.txt"

curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://mise.run | sh
curl -fsSL https://opencode.ai/install | sh
~/.local/bin/mise use --global ansible glab

notify-send "Fedora Hyprland Remix" "Configurazione Terminata" --icon=system-software-install
FIRSTLOGIN
chmod 755 /usr/bin/first-login-setup.sh

cat > /usr/share/fedora-hyprland-remix/flatpak-apps.txt << 'FLATPAK'
org.libreoffice.LibreOffice
org.videolan.VLC
com.obsproject.Studio
com.spotify.Client
com.usebruno.Bruno
org.telegram.desktop
com.brave.Browser
io.gitlab.librewolf-community
org.mozilla.Thunderbird
nz.mega.MEGAsync
FLATPAK

cat > /usr/share/fedora-hyprland-remix/vscode-extensions.txt << 'VSEXT'
Catppuccin.catppuccin-vsc
PKief.material-icon-theme
eamodio.gitlens
mhutchie.git-graph
usernamehw.errorlens
alefragnani.project-manager
redhat.ansible
esbenp.prettier-vscode
adpyke.codesnap
formulahendry.code-runner
yzhang.markdown-all-in-one
chrmarti.regex
ms-vscode-remote.remote-containers
VSEXT

mkdir -p /usr/lib/systemd/user
cat > /usr/lib/systemd/user/first-login-setup.service << 'UNIT'
[Unit]
Description=First login setup for Fedora Hyprland Remix
ConditionPathExists=!%h/.config/fedora-hyprland-remix/.first-login-done

[Service]
Type=oneshot
ExecStart=/usr/bin/first-login-setup.sh
ExecStartPost=/bin/bash -c 'mkdir -p %h/.config/fedora-hyprland-remix && touch %h/.config/fedora-hyprland-remix/.first-login-done'

[Install]
WantedBy=default.target
UNIT
systemctl --global enable first-login-setup.service

# ── Cleanup ───────────────────────────────────────────────────────────────────
dnf -y clean all
rm -rf /tmp/*
%end
