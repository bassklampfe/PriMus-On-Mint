#!/bin/bash
set -e
#------------------------------------------------------------
# this script installes required packages needed to run
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------


#
# install required packages
#
sudo apt install \
	zenity \
	wget \
	unrar \
	timidity \
	fluid-soundfont-gm \
	fluid-soundfont-gs \
	lame \
	icoutils \
	wine-stable \
	winetricks \
	printer-driver-cups-pdf \
	imagemagick

#
# timidity-daemon is not functional, remove it now 
#
sudo apt remove timidity-daemon

#
# enable soundfound fluidr3_gm
#
test -f /etc/timidity/timidity.cfg.orig || sudo cp /etc/timidity/timidity.cfg /etc/timidity/timidity.cfg.orig
sudo perl -pi \
	-e's:^source /etc/timidity/freepats.cfg:#source /etc/timidity/freepats.cfg:;' \
	-e's:^#source /etc/timidity/fluidr3_gm.cfg:source /etc/timidity/fluidr3_gm.cfg:;' \
	/etc/timidity/timidity.cfg

#~ test -f /etc/default/timidity.orig || sudo cp /etc/default/timidity /etc/default/timidity.orig
#~ sudo cp /etc/default/timidity.orig /etc/default/timidity
#~ #
#~ sudo perl -pi \
	#~ -e's:^TIM_ALSASEQPARAMS=.*:TIM_ALSASEQPARAMS="--output-24bit -A120 -A --buffer-fragments-2,8":;' \
	#~ /etc/default/timidity



#~ test -f /etc/pulse/daemon.conf.orig || sudo cp /etc/pulse/daemon.conf /etc/pulse/daemon.conf.orig
#~ sudo cp /etc/pulse/daemon.conf.orig /etc/pulse/daemon.conf
#~ sudo perl -pi \
	#~ -e's:^; daemonize = no:daemonize = yes:;' \
	#~ /etc/pulse/daemon.conf
#~ diff /etc/pulse/daemon.conf*

#
# add user to audio group
#
sudo usermod -a -G audio "${USER}"


#
# create an autostart entry to get timidity run when user logs in
#
mkdir -p ${HOME}/.config/autostart
cat  << -EOF- > "${HOME}/.config/autostart/Timidity.desktop"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Timidity
Comment=
Exec=/usr/bin/timidity --output-16bit -A70 -iA --buffer-fragments=2,8 --background
StartupNotify=false
Terminal=false
Hidden=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=0
-EOF-
chmod +x ${HOME}/.config/autostart/Timidity.desktop
