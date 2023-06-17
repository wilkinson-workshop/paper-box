#!/bin/bash

# Installs required system tools and performs any
# setup.

declare -A PACMAN_MAP;
PACMAN_MAP[/etc/redhat-release]=yum
PACMAN_MAP[/etc/arch-release]=pacman
PACMAN_MAP[/etc/gentoo-release]=emerge
PACMAN_MAP[/etc/SuSE-release]=zypp
PACMAN_MAP[/etc/debian_version]=apt-get
PACMAN_MAP[/etc/alpine-release]=apk

# Identify the distribution from PACMAN_MAP. If
# we can find the distribution we should be able
# to find the package manager.
for dist in ${!PACMAN_MAP[@]}
do
    if [[ -f $dist ]]; then
        distribution=$dist
    fi
done

init() {
    install

    # Initialize our firewall to allow select
    # ports.
    sudo ufw allow 25565:35580/tcp  # Minecraft Server
    sudo ufw allow 443              # HTTPS/SSL
    sudo ufw allow 80               # HTTP
    sudo ufw allow OpenSSH          # SSH
    sudo ufw enable
}

install() {
    REQUIRED_TOOLS="wget rsync docker ufw certbot ddclient"

    if [[ $distribution == "/etc/alpine-release" ]]; then
        sudo ${PACMAN_MAP[$distribution]} add --no-cache $REQUIRED_TOOLS
    elif [[ $distribution ]]; then
        sudo ${PACMAN_MAP[$distribution]} install $REQUIRED_TOOLS
    else
        echo -e "could not find package manager."
        exit 1
    fi
}

$@
