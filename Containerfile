FROM quay.io/fedora/fedora-bootc:latest
ENV BASE_PKG="tmux polkit gnome-shell unzip neovim vim-default-editor htop qemu-guest-agent distrobox flatpak base-graphical container-management hardware-support gnome-desktop guest-desktop-agents"
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf copr enable scottames/ghostty && \
    dnf install ghostty && \
    dnf install -y ${BASE_PKG} && \
    dnf clean all
RUN systemctl set-default graphical.target
RUN bootc container lint
