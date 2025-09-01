FROM quay.io/fedora/fedora-bootc:latest

# -- Package installation --
## Enable RPM Fusion repositories
## https://rpmfusion.org/
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## Add Ghostty repository
RUN . /etc/os-release; curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo

ENV BASE_PKG="tmux gnome-shell unzip neovim htop qemu-guest-agent ghostty distrobox flatpak @container-management @hardware-support @guest-desktop-agents zsh rsync niri ecryptfs-utils swaylock dconf gdm nautilus polkit avahi xdg-desktop-portal @base-graphical"
RUN dnf install -y ${BASE_PKG}

# GNOME packages (mandatory, default, optional)
ENV GNOME_PKG="dconf gdm gnome-boxes gnome-connections gnome-control-center gnome-initial-setup gnome-session-wayland-session gnome-settings-daemon gnome-shell gnome-software gnome-text-editor nautilus polkit ptyxis yelp \
ModemManager NetworkManager-adsl NetworkManager-openconnect-gnome NetworkManager-openvpn-gnome NetworkManager-ppp NetworkManager-pptp-gnome NetworkManager-ssh-gnome NetworkManager-vpnc-gnome NetworkManager-wwan PackageKit-command-not-found PackageKit-gtk3-module adobe-source-code-pro-fonts avahi baobab evince evince-djvu fprintd-pam glib-networking gnome-backgrounds gnome-bluetooth gnome-browser-connector gnome-calculator gnome-calendar gnome-characters gnome-classic-session gnome-clocks gnome-color-manager gnome-contacts gnome-disk-utility gnome-epub-thumbnailer gnome-font-viewer gnome-logs gnome-maps gnome-remote-desktop gnome-system-monitor gnome-user-docs gnome-user-share gnome-weather gvfs-afc gvfs-afp gvfs-archive gvfs-fuse gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb librsvg2 libsane-hpaio localsearch loupe mesa-dri-drivers mesa-libEGL rygel sane-backends-drivers-scanners simple-scan snapshot sushi systemd-oomd-defaults tinysparql totem xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs-gtk \
gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly vlc"
RUN dnf install -y ${GNOME_PKG} && \
    dnf clean all

# -- User setup --
ARG USERNAME
ARG PASSWORD

RUN groupadd -g 1000 ${USERNAME} \
    && useradd -m -u 1000 -g 1000 -G wheel,ecryptfs -s /bin/zsh -K MAIL_DIR=/dev/null ${USERNAME} \
    && echo "${USERNAME}:${PASSWORD}" | chpasswd \
    && mkdir -p /home/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME} \
    && chmod 700 /home/${USERNAME} \
    && echo 'ecryptfs' >> /etc/modules-load.d/ecryptfs.conf
ADD --chown=1000:1000 home /home/${USERNAME}/
## Once the setup is complete, run the following command to migrate the home directory
## "sudo ecryptfs-migrate-home -u ${USERNAME}"

# -- Add configuration files --
ADD usr usr
ADD etc etc
RUN dconf update
ADD  --chown=0:0 home/.ssh /root/.ssh

RUN mkdir -p /nix && touch /nix/.keep

# -- Finalize container setup --
RUN systemctl set-default graphical.target
RUN bootc container lint
