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


#--------------------------------------------------
# install actions for nautilus
#--------------------------------------------------
if  [ -f /usr/bin/nautilus ]
then
	mkdir -p "$HOME/.local/share/file-manager/actions"
	
cat  << -EOF- > "${HOME}/.local/share/file-manager/actions/primus2mp3.desktop"
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Action
ToolbarLabel=PriMus MP3
Name=Convert PriMus to MP3
Comment=Convert PriMus to MP3
Profiles=profile-zero;

[X-Action-Profile profile-zero]
Folders=*;
Exec=${HOME}/bin/primus2mp3.sh %F
Icon-Name=audio-mpeg
TargetLocation=true
MymeTypes=application/columbussoft-primus-pridoc;application/columbussoft-primus-prbdoc;application/columbussoft-primus-emildoc;application/columbussoft-primus-emixdoc;
-EOF-

cat  << -EOF- > "${HOME}/.local/share/file-manager/actions/primus2pdf.desktop"
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Action
ToolbarLabel=PriMus PDF
Name=Convert PriMus to PDF
Comment=Convert PriMus to PDF
Profiles=profile-zero;

[X-Action-Profile profile-zero]
Folders=*;
Exec=${HOME}/bin/primus2pdf.sh %F
Icon-Name=application-pdf
TargetLocation=true
MymeTypes=application/columbussoft-primus-pridoc;application/columbussoft-primus-prbdoc;application/columbussoft-primus-emildoc;application/columbussoft-primus-emixdoc;
-EOF-


fi

#--------------------------------------------------
# install actions for thunar
#--------------------------------------------------
if  [ -f /usr/bin/thunar ]
then
	if [ ! -f ]
	then
		echo "<actions></actions>" > ~/.config/Thunar/uca.xml
	fi

	PRIMUS_TO_PDF="<action>\n\t<icon>columbussoft-primus</icon>\n\t<name>PriMus to PDF</name>\n\t<command>${HOME}/bin/primus2pdf.sh %F</command>\n\t<description></description>\n\t<patterns>*.pri</patterns>\n\t<other-files/>\n\t<text-files/>\n</action>\n"
	echo "PRIMUS_TO_PDF='${PRIMUS_TO_PDF}'"
	
	PRIMUS_TO_MP3="<action>\n\t<icon>columbussoft-primus</icon>\n\t<name>PriMus to MP3</name>\n\t<command>${HOME}/bin/primus2mp3.sh %F</command>\n\t<description></description>\n\t<patterns>*.pri</patterns>\n\t<other-files/>\n\t<text-files/>\n</action>\n"
	echo "PRIMUS_TO_MP3='${PRIMUS_TO_MP3}'"

	perl -0777 -pi~ \
			-e 's:<action>\s*<icon>\w+-primus</icon>.*?</action>\n*::sg;' \
		-e "s:</actions>:${PRIMUS_TO_PDF}${PRIMUS_TO_MP3}</actions>:sg;" \
		~/.config/Thunar/uca.xml

	Thunar -q
fi
