FROM quay.io/fedora/fedora-bootc:latest
# Enable RPM Fusion repositories
# https://rpmfusion.org/
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Add Ghostty repository
RUN . /etc/os-release; curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo

ENV BASE_PKG="tmux gnome-shell unzip neovim htop qemu-guest-agent ghostty distrobox flatpak @base-graphical @container-management @hardware-support @gnome-desktop @guest-desktop-agents zsh sway zsh rsync"
RUN dnf install -y ${BASE_PKG} && \
    dnf clean all
RUN dnf install -y ecryptfs-utils
RUN groupadd -g 1000 qjoly || true \
    && useradd -m -u 1000 -g 1000 -G wheel -s /bin/zsh -K MAIL_DIR=/dev/null qjoly \
    && echo 'qjoly:changeme' | chpasswd \
    && mkdir -p /home/qjoly \
    && chown qjoly:qjoly /home/qjoly \
    && chmod 700 /home/qjoly \
    && echo 'ecryptfs' >> /etc/modules-load.d/ecryptfs.conf
ADD --chown=1000:1000 home /home/qjoly/
# su - qjoly -c "ecryptfs-migrate-home -u qjoly"
RUN systemctl set-default graphical.target
ADD usr usr
ADD etc etc
RUN dconf update
RUN bootc container lint
