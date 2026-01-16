#!/bin/bash
set -e

#------------------------------------------------------------
# this script downlaod required files needed to setup
# PriMus from Columbussoft on Linux using wine
#------------------------------------------------------------
mkdir -p downloads
declare -A DOWNLOADs
DOWNLOADs=(
["innounp049.rar"]="https://master.dl.sourceforge.net/project/innounp/innounp/innounp%200.49/innounp049.rar"
["SetupPriMus.exe"]="https://www.columbussoft.de/download/SetupPriMus.exe"
)

for file in "${!DOWNLOADs[@]}"
do
	if [ -f "downloads/${file}" ]
	then
		echo "EXISTS ${file}"
	else
		echo "FETCH ${file} from ${DOWNLOADs[${file}]}"
		wget -O "downloads/${file}.part" "${DOWNLOADs[${file}]}"
		mv "downloads/${file}.part" "downloads/${file}"
	fi
done
