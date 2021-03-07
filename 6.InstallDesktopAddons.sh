#!/bin/bash

#--------------------------------------------------
# install scripts
#--------------------------------------------------
mkdir -p ${HOME}/bin
cp -v bin/*.sh ${HOME}/bin/

#--------------------------------------------------
# install actions for nemo
#--------------------------------------------------
if  [ -f /usr/bin/nemo ]
then
	mkdir -p "${HOME}/.local/share/nemo/actions"
cat  << -EOF- > "${HOME}/.local/share/nemo/actions/primus2pdf.nemo_action"
[Nemo Action]
Name=Convert %e to PDF
Comment=Convert %e to PDF
Exec=${HOME}/bin/primus2pdf.sh %F
Icon-Name=application-pdf
Selection=notnone
Extensions=pri;
Quote=double
-EOF-

cat  << -EOF- > "${HOME}/.local/share/nemo/actions/primus2mp3.nemo_action"
[Nemo Action]
Name=Convert %e to MP3
Comment=Convert %e to MP3
Exec=${HOME}/bin/primus2mp3.sh %F
Icon-Name=audio-mpeg
Selection=notnone
Extensions=pri;
Quote=double
-EOF-


fi

 
#--------------------------------------------------
# install actions for dolphin
#--------------------------------------------------
if  [ -f /usr/bin/dolphin ]
then
	mkdir -p "$HOME/.local/share/kservices5/ServiceMenus"
	
cat  << -EOF- > "${HOME}/.local/share/kservices5/ServiceMenus/Primus.desktop"
[Desktop Entry]
Type=Service
X-KDE-ServiceTypes=KonqPopupMenu/Plugin
MimeType=application/columbussoft-primus-pridoc;
Actions=primus2mp3;primus2pdf;
Icon=columbussoft-primus
Encoding=UTF-8

[Desktop Action primus2mp3]
Name=Convert primus to MP3
Exec=${HOME}/bin/primus2mp3.sh %F
Icon=audio-mpeg

[Desktop Action primus2pdf]
Name=Convert primus to PDF
Exec=${HOME}/bin/primus2pdf.sh %F
Icon=application-pdf
-EOF-


fi
