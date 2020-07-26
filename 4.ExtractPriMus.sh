#!/bin/bash
set -e
#--------------------------------------------------
# since SetupPriMus creates a lot of garbage file assosiations
# with winemenubuilder
# we extract it by hand
#--------------------------------------------------
# set WINEPREFIX for PRIMUS
export WINEPREFIX="${HOME}/.wine-primus"

if [ ! -f downloads/innounp.exe ]
then
	(cd downloads && unrar e innounp049.rar)
fi

rm -rf downloads/SetupPriMus
wine downloads/innounp.exe -x -a "-ddownloads/SetupPriMus" "downloads/SetupPriMus.exe"
rm -rf "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus"
mv -vi "downloads/SetupPriMus/{app}/" "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus"
cp -va "downloads/SetupPriMus/{fonts}/"*.TTF "${WINEPREFIX}/drive_c/windows/Fonts/"
if [ -f ~/license.dat ] ; then cp ~/license.dat "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/" ; fi
