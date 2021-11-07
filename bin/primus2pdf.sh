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
			#
			# copy primus file into temp folder (to avoid issues with special chars in paths)
			#
			pri=$(basename "${pri_path}")
			#pri=${pri//[^[:alnum:].]/_}
			echo "pri='${pri}'"
			cp "${pri_path}" "/tmp/${pri}"

			#
			# determ expected output name of PDF (depending on switch in primus)
			#
			prinam=$(echo -n ${pri%.pri}|iconv -f UTF-8 -t ISO-8859-14 - |perl -pe 's/[^.a-zA-Z0-9\x80-\xFF+-]/_/g;s/([\x80-\xFF])/sprintf("_%03o",ord($1))/ge;')
			echo "prinam ='${prinam}'"
			
			nam1=${prinam:0:64} ; nam1="$(echo -n ${nam1}| perl -pe 's/_+$//')"
			prinam=PriMus_-_${prinam}
			nam2=${prinam:0:64} ; nam2="$(echo -n ${nam2}| perl -pe 's/_+$//')"
			echo "nam1='${nam1}'"
			echo "nam2='${nam2}'"
			
			#
			# do the print
			#
			echo "Print '${pri}' => '${nam}'  => '${pdf}'"
			rm -f "${HOME}/PDF/${nam1}"*.pdf "${HOME}/PDF/${nam2}"*.pdf
			wine 'C:\Program Files (x86)\PriMus\PriMus.exe' -PRN "PDF" -P "z:/tmp/${pri}"
			#env WINEPREFIX="${HOME}/.wine" wine 'C:\Program Files (x86)\PriMus\PriMus.exe' -PRN "PDF" -P z:"/tmp/${pri}" || true
			echo "Printed status $?"
			sleep 1
			#
			# wanted file names in folder of primus document
			#
			pdf=${pri_path%.pri}.pdf
			oldpdf=${pri_path%.pri}-old.pdf
			pdfpdf=$(find ${HOME}/PDF/ -name "${nam1}*.pdf" -or -name "${nam2}*.pdf")
			echo "pdfpdf='${pdfpdf}'"

			#
			# rename files to targed
			#
			test -f "${pdf}"    && mv "${pdf}" "${oldpdf}"
			test -f "${pdfpdf}" && mv -v "${pdfpdf}" "${pdf}"  && touch --no-create --reference "${pri_path}"  "${pdf}"
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

