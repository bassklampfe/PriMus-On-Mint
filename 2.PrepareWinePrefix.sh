#!/bin/bash
set -e

#------------------------------------------------------------
# this script prepares a seperate wineprefix for running 
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------

# Since microsoft has removed the download and 
# winetricks then falls back to the very slow internet archive
# we will prefetch the huge kb files from faster source
for kb in windows6.1-KB976932-X86.exe windows6.1-KB976932-X64.exe
do
	if [ ! -f ${HOME}/.cache/winetricks/win7sp1/${kb} ]
	then
		mkdir -p ${HOME}/.cache/winetricks/win7sp1/
		wget http://www-pc.uni-regensburg.de/systemsw/win7/sp1/${kb} \
		-O ${HOME}/.cache/winetricks/win7sp1/${kb}
	fi
done
export WINEPREFIX="${HOME}/.wine-primus"
rm -rf "${WINEPREFIX}"
# setup wine environment (will recreate dir)
winetricks --unattended corefonts lucida gdiplus vcrun2005

