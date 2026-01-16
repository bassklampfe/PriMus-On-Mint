#!/bin/bash

#----------------------------------
# define desktop file
#----------------------------------
echo "-- create additinal starters --"
cat  << -EOF- > /tmp/columbussoft-primus-winecfg.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Exec=bash -c 'WINEPREFIX="${HOME}/.wine-primus" winecfg'
Terminal=false
Icon=columbussoft-primus
Name=WineCfg for PriMus!
-EOF-
chmod +x /tmp/columbussoft-primus-winecfg.desktop
xdg-desktop-menu install --mode user /tmp/columbussoft-primus-winecfg.desktop

cat  << -EOF- > /tmp/columbussoft-primus-teamviewer.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Exec=bash -c 'WINEPREFIX="${HOME}/.wine-primus" wine "C:/Program Files (x86)/PriMus/System/TeamViewer.exe"'
Terminal=false
Icon=columbussoft-primus
Name=TeamViewer for PriMus!
-EOF-
chmod +x /tmp/columbussoft-primus-teamviewer.desktop
xdg-desktop-menu install --mode user /tmp/columbussoft-primus-teamviewer.desktop