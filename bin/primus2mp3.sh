#!/bin/bash
#============================================================
# this script takes a list of primus-files 
# - use primus to export to midi
# - use timidity to convert to wav
# - use lame to convert to mp3
#============================================================
#set -x
export WINEDEBUG=-all
export WINEPREFIX="${HOME}/.wine-primus"

function pri2mp3
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
			pri=${pri//[^[:alnum:].]/_}
			echo "pri='${pri}'"
			cp "${pri_path}" "/tmp/${pri}"
			#
			# determ expected output name of PDF (depending on "
			#

			name=$(basename "${pri}")
			mid="/tmp/${name%.*}.mid"
			wav="/tmp/${name%.*}.wav"
			mp3=${pri_path%.*}.mp3
			echo "PRI=${pri}"
			echo "MID=${mid}"
			echo "WAV=${wav}"
			echo "MP3=${mp3}"
			rm -f "${mid}" "${wav}"

			echo "--- pri > mid ---"
			wine 'C:\Program Files (x86)\PriMus\PriMus.exe' -EM "z:/tmp/${pri}"

			if [ ! -f "${mid}" ]
			then
				echo "no MID '${mid}' exported"
				ls -l /tmp/*.mid
			else
				if [[ "${name}" =~ [kc]licktrack ]]
				then
					mono="--output-mono --ext=F reverb=d,delay=d"
				fi
				echo "--- mid > wav ---"
				timidity \
				--no-trace \
				${mono} \
				-A70 \
				-a -id -Ow "${mid}" -o "${wav}"

				echo "--- wav > mp3 ---"
				lame --silent --nohist -h -V 4 "${wav}" "${mp3}"
				rm -f "${mid}" "${wav}"
			fi
		fi
	done
	echo "*** ALL DONE ***"
}

if [ -t 1 ] 
then 
	pri2mp3 "$@"
else
	(
	pri2mp3 "$@"
	) 2>&1 | zenity --text-info --text="" \
		--title "Primus to MP3" \
		--auto-scroll \
		--width=800 --height=600 --no-wrap 
fi

