#!/bin/bash
set -e

#------------------------------------------------------------
# this script prepares a seperate wineprefix for running 
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------

export WINEPREFIX="${HOME}/.wine-primus"
rm -rf "${WINEPREFIX}"
# setup wine environment (will recreate dir)
winetricks corefonts gdiplus vcrun2005

