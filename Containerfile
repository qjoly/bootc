FROM quay.io/fedora/fedora-bootc:latest
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && dnf install -y tmux polkit sway unzip && dnf clean all
RUN systemctl set-default graphical.target
