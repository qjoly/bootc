#!/bin/bash


set -e

# Function to add Flathub repository if not present
add_flathub_repo() {
    if ! flatpak remote-list | grep -q flathub; then
        echo "Adding Flathub repository..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        echo "Flathub repository already exists."
    fi
}

# Function to install a Flatpak application
install_flatpak_app() {
    APP_ID="$1"
    if flatpak list | grep -q "$APP_ID"; then
        echo "Flatpak application '$APP_ID' is already installed."
    else
        echo "Installing Flatpak application '$APP_ID'..."
        flatpak install -y flathub "$APP_ID"
    fi
}

# Main script
add_flathub_repo


FLATPAK_APPS=(
    "org.mozilla.firefox"
    "com.discordapp.Discord"
    "org.mozilla.Thunderbird"
    "com.spotify.Client"
)

for app in "${FLATPAK_APPS[@]}"; do
    install_flatpak_app "$app"
done


echo "Done."