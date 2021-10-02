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

wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
# setup wine environment (will recreate dir)
./winetricks --unattended corefonts lucida gdiplus vcrun2005

