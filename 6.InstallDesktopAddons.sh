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

 