#!/bin/bash

find ${HOME}/.local/share/applications -name "columbussoft-primus*.desktop" |
xargs --no-run-if-empty -d '\n' xdg-desktop-menu uninstall --mode user


DESKTOP=$(xdg-user-dir DESKTOP)
find ${DESKTOP}/ -name columbussoft-primus.desktop -delete


for png in $(find ${HOME}/.local/share/icons/hicolor -name "columbussoft-primus*.png") ;
do
	item=$(basename "${png}" .png)
	size=$(convert "${png}" -print "%w" /dev/null)
	echo "png='${png}' size='${size}' item='${item}'"
	xdg-icon-resource uninstall --mode user --size ${size}  ${item}
done
find ${HOME}/.local/share/icons/hicolor/ -name "*PriMus.0.png" -print -delete

find ${HOME}/.local/share/mime/packages -name "columbussoft-primus*.xml" -type f | \
	xargs --no-run-if-empty -d '\n' xdg-mime uninstall --mode user
	
find ${HOME}/.local/share/mime/packages -name "x-wine-extension-*.xml" -type f | \
	xargs --no-run-if-empty -d '\n' xdg-mime uninstall --mode user

find ~/.local -iname "*primus*" -print -delete
find ~/.local -iname "*wine*" -print -delete
