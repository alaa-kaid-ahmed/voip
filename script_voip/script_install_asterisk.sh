#!/bin/bash

# Variables
ASTERISK_VERSION="18-current"
ASTERISK_DOWNLOAD_URL="https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz"
ASTERISK_ARCHIVE="asterisk-${ASTERISK_VERSION}.tar.gz"
ASTERISK_DIR="/usr/src/asterisk-${ASTERISK_VERSION}"

# 1. Mise à jour du système
apt update && apt upgrade -y

# 2. Téléchargement d'Asterisk
cd /usr/src
wget $ASTERISK_DOWNLOAD_URL

# 3. Installation des dépendances
DEPENDENCIES="build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev libjansson-dev git subversion"
apt install $DEPENDENCIES -y

# 4. Extraction de l'archive Asterisk
tar -xvf $ASTERISK_ARCHIVE

# 5. Installation d'Asterisk
cd $ASTERISK_DIR
contrib/scripts/get_mp3_source.sh
contrib/scripts/install_prereq install
./configure
make menuselect
make
make install
make samples
make config
ldconfig

# Démarrage du service Asterisk
systemctl start asterisk

# Connexion au shell d'Asterisk
asterisk -rvvv
