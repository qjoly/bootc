FROM quay.io/fedora/fedora-bootc:latest
# Enable RPM Fusion repositories
# https://rpmfusion.org/
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# Add Ghostty repository
RUN . /etc/os-release; curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo

ENV BASE_PKG="tmux gnome-shell unzip neovim htop qemu-guest-agent ghostty distrobox flatpak @base-graphical @container-management @hardware-support @gnome-desktop @guest-desktop-agents"
RUN dnf install -y ${BASE_PKG} && \
    dnf clean all
RUN systemctl set-default graphical.target
ADD usr usr
ADD etc etc
RUN bootc container lint
