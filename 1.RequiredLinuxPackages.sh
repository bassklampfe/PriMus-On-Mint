#!/bin/bash
set -e
#------------------------------------------------------------
# this script installes required packages needed to run
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------


#
# install required packages
#
sudo apt update

sudo apt install \
	zenity \
	wget \
	unrar \
	timidity \
	fluidsynth \
	fluid-soundfont-gm \
	fluid-soundfont-gs \
	lame \
	icoutils \
	wine-stable \
	winetricks \
	printer-driver-cups-pdf \
	imagemagick
	
if  [ -f /usr/bin/nautilus ]
then
	sudo apt install nautilus-actions
fi



#
# timidity-daemon is not functional, remove it now 
#
sudo apt remove timidity-daemon || true

#
# add user to audio group
#
sudo usermod -a -G audio "${USER}"
