#!/bin/bash
set -e
#------------------------------------------------------------
# this script creates desktop and file assosiations needed for
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------

export WINEPREFIX="${HOME}/.wine-primus"

#
# extract application icons from EXE
#
ICONDIR=downloads/SetupPriMus/Icons
rm -rf ${ICONDIR}
mkdir -p ${ICONDIR}
wrestool -x "--output=${ICONDIR}/" -t14 "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/PriMus.exe"
(cd ${ICONDIR} && convert *.ico -set filename:mysize "columbussoft-primus-%wx%h" "%[filename:mysize].png")
cp "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/System/emildoc.ico" "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/System/emixdoc.ico" 
for ico in "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/System/"*.ico
do
	echo "ico='${ico}'"
	name=$(basename "${ico}" ".ico")
	(cd ${ICONDIR} && convert "${ico}" -set filename:mysize "columbussoft-primus-${name}-%wx%h" "%[filename:mysize].png")
done
#
# install application icons to resources
#
for png in downloads/SetupPriMus/Icons/*.png
do
	echo "png='${png}'"
	name=$(basename "${png}" ".png")
	size=$(convert "${png}" -print "%w" /dev/null)
	item=${name%-*}
	echo "name='${name}' item='${item}' size='${size}'"
	xdg-icon-resource install --mode user --size ${size} ${png} ${item}
done


#
# create a simple command line script for primus to allow start 
# it verifies, there is a timidity server running.
#
mkdir -p ~/bin
cat  << -EOF- > ~/bin/primus
#!/bin/bash
if ! pgrep timidity
then
	zenity --error --width=320 --text "Timidity not running\nCannot start PriMus as it would freeze"
	exit 1
fi
export WINEPREFIX="${HOME}/.wine-primus"
export WINEDLLOVERRIDES=winemenubuilder.exe=d
wine "\${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/PriMus.exe" "\$@"
-EOF-
chmod +x ~/bin/primus

function create_mime
{
#----------------------------------
# define mime type with icon
#----------------------------------
echo "-- create mime type --"
cat << -EOF- > /tmp/columbussoft-primus-$1.xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/columbussoft-primus-$1">
	<comment>$2</comment>
	<glob pattern=$3/>
	<icon name="columbussoft-primus-$1"/>
  </mime-type>
</mime-info>
-EOF-
xdg-mime install --mode user /tmp/columbussoft-primus-$1.xml


}
create_mime "pridoc" "PriMus-Datei" '"*.pri"'
create_mime "prbdoc" "PriMus-Backup" '"*.prb"'
create_mime "emildoc" "Emil-Datei" '"*.emil"'
create_mime "emixdoc" "Emix-Datei" '"*.emix"'

#----------------------------------
# define desktop file
#----------------------------------
echo "-- create application type --"
cat  << -EOF- > /tmp/columbussoft-primus.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
MimeType=application/columbussoft-primus-pridoc;application/columbussoft-primus-prbdoc;application/columbussoft-primus-emildoc;application/columbussoft-primus-emixdoc;
Exec=${HOME}/bin/primus %F
##Categories=Audio;
Terminal=false
Icon=columbussoft-primus
Name=PriMus!
-EOF-
chmod +x /tmp/columbussoft-primus.desktop
xdg-desktop-menu install --mode user /tmp/columbussoft-primus.desktop

cp /tmp/columbussoft-primus.desktop /home/test/Desktop/	
if [ -f ~/license.dat ] ; then cp ~/license.dat "${WINEPREFIX}/drive_c/Program Files (x86)/PriMus/" ; fi

find ~/.local -iname "*primus*"
