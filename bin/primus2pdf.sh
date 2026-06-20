#!/bin/bash
#============================================================
# this script takes a list of primus-files and convert them
# to PDF in the same folder
#============================================================
# set -x
export WINEDEBUG=-all
export WINEPREFIX="${HOME}/.wine-primus"

function pri2pdf 
{
	for pri_path in "$@"
	do
		# fix nemo quoting
		pri_path=${pri_path//\\\'/\'}
		echo "======= ${pri_path} ======"
		if [ -f "${pri_path}" ]
		then
			real_path=$(realpath "${pri_path}")
			echo "real_path='${real_path}'"
			real_dir=$(dirname "${real_path}")
			echo "real_dir='${real_dir}'"
			real_name=$(basename "${real_path}")
			echo "real_name='${real_name}'"
	
			pdf=${real_path%.pri}.pdf
			
			#
			# do the print
			#
			echo "Print '${real_name}' => '${pdf}'"
			(
				cd "${real_dir}"
				wine 'C:\Program Files (x86)\PriMus\PriMus.exe' -PRN "PDF" -P "${real_name}"
				echo "Printed status $?"
			)
			
			#
			# wait for the printed file to appear in the PDF folder
			#
			set -x
			inotifywait=$(inotifywait -e CLOSE_WRITE --format '%f' --timeout 30 "${HOME}/PDF")
			echo "inotifywait='${inotifywait}'"
			sleep 2
			set +x

			#
			# wanted file names in folder of primus document
			#
			oldpdf=${real_path%.pri}-old.pdf
			newpdf="${HOME}/PDF/${inotifywait}"
			echo "newpdf='${newpdf}'"
			if [ -f "${newpdf}" ]
			then
				#
				# rename files to targed
				#
				test -f "${pdf}"    && mv -v "${pdf}" "${oldpdf}"
				test -f "${newpdf}" && mv -v "${newpdf}" "${pdf}" && touch --no-create --reference "${real_path}"  "${pdf}"
			fi
		fi
	done
	echo "*** ALL DONE ***"
}

if [ -t 1 ] 
then 
	pri2pdf "$@"
else
	(
	set -e
	pri2pdf "$@"
	) 2>&1 | zenity --text-info --text="" \
		--title "Primus to PDF" \
		--auto-scroll \
		--width=800 --height=600 --no-wrap
fi

