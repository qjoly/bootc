FROM quay.io/fedora/fedora-bootc:latest

ARG USERNAME
ARG PASSWORD

# -- Package installation --
## Enable RPM Fusion repositories
## https://rpmfusion.org/
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## Add Ghostty repository
RUN . /etc/os-release; curl -fsSL "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" | tee /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:scottames:ghostty.repo

ENV BASE_PKG="tmux gnome-shell unzip neovim htop qemu-guest-agent ghostty distrobox flatpak @base-graphical @container-management @hardware-support @gnome-desktop @guest-desktop-agents zsh sway rsync"
RUN dnf install -y ${BASE_PKG} && \
    dnf clean all

# -- User setup --
RUN dnf install -y ecryptfs-utils
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
ADD  --chown=0:0 home/.ssh /root/

# -- Install Nix --
ENV NIX_INSTALLER_START_DAEMON=false
## --no-start-daemon to avoid starting the nix-daemon service in the container (which could cause issues since systemd is not up)
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install ostree --no-confirm --no-start-daemon --persistence=/var/lib/nix
# -- Finalize container setup --
RUN systemctl set-default graphical.target
RUN bootc container lint
