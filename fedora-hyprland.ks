# Fedora Hyprland Remix — Live ISO Kickstart
# Base: Fedora 44 | WM: Hyprland 0.55.x (COPR sdegler/hyprland)
# Build: livemedia-creator --ks fedora-hyprland.ks --no-virt --project Fedora-Hyprland-Remix --releasever 44 --iso-only

lang it_IT.UTF-8
keyboard it
timezone Europe/Rome --isUtc

# ── Repositories ──────────────────────────────────────────────────────────────
repo --name=fedora --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/ --gpgcheck=1
repo --name=updates --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/updates/44/Everything/x86_64/ --gpgcheck=1
repo --name=rpmfusion-free --baseurl=https://mirrors.rpmfusion.org/free/fedora/releases/44/Everything/x86_64/os/ --gpgcheck=1
repo --name=rpmfusion-nonfree --baseurl=https://mirrors.rpmfusion.org/nonfree/fedora/releases/44/Everything/x86_64/os/ --gpgcheck=1
repo --name=hyprland --baseurl=https://download.copr.fedorainfracloud.org/results/sdegler/hyprland/fedora-44-x86_64/ --gpgcheck=1

# ── Packages ──────────────────────────────────────────────────────────────────
%packages
@core
@standard

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

# ── Live environment ──────────────────────────────────────────────────────────
plymouth
plymouth-theme-spinner
%end

# ── Copy build files into chroot ──────────────────────────────────────────────
%post --nochroot --log=/root/ks-post-nochroot.log
set -euo pipefail

BUILD_DIR="/tmp/fedora-hyprland-remix-build"

if [ -d "${BUILD_DIR}" ]; then
    cp -a "${BUILD_DIR}/config" "${INSTALL_ROOT}/tmp/ks-config"
    cp -a "${BUILD_DIR}/scripts" "${INSTALL_ROOT}/tmp/ks-scripts"
    cp -a "${BUILD_DIR}/units" "${INSTALL_ROOT}/tmp/ks-units"
    echo "Build files copied to chroot"
else
    echo "WARNING: Build directory ${BUILD_DIR} not found"
fi
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
mkdir -p /etc/skel
cp -a /tmp/ks-config/common/.config /etc/skel/
cp -a /tmp/ks-config/common/.local /etc/skel/
cp /tmp/ks-config/common/.bashrc /etc/skel/
cp /tmp/ks-config/common/.bash_profile /etc/skel/
cp /tmp/ks-config/common/.bash_aliases /etc/skel/
cp /tmp/ks-config/common/.nanorc /etc/skel/
cp -a /tmp/ks-config/hyprland/.config /etc/skel/

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
cp /tmp/ks-scripts/first-login-setup.sh /usr/bin/first-login-setup.sh
chmod 755 /usr/bin/first-login-setup.sh
cp /tmp/ks-scripts/flatpak-apps.txt /usr/share/fedora-hyprland-remix/
cp /tmp/ks-scripts/vscode-extensions.txt /usr/share/fedora-hyprland-remix/

mkdir -p /usr/lib/systemd/user
cp /tmp/ks-units/first-login-setup.service /usr/lib/systemd/user/
systemctl --global enable first-login-setup.service

# ── Cleanup ───────────────────────────────────────────────────────────────────
dnf -y clean all
rm -rf /tmp/*
%end
