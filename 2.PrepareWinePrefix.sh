#!/bin/bash
set -e

#------------------------------------------------------------
# this script prepares a seperate wineprefix for running 
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------
export WINEPREFIX="${HOME}/.wine-primus"
rm -rf "${WINEPREFIX}"

# Since microsoft is frequently moving files
# get a fresh copy of wintricks for updated URLs
mkdir -p downloads
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O downloads/winetricks
chmod +x downloads/winetricks
# setup wine environment (will recreate dir)
downloads/winetricks --unattended corefonts lucida gdiplus vcrun2005

