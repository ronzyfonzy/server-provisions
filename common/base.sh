#!/usr/bin/env bash

EXEC_DIR="/${PWD##*/}"
YES_TO_ALL=0
SILENT=0

function ProgressBar {
	let _progress=${1}*100/${2}*100
	let _progress=_progress/100
	let _done=${_progress}*4
	let _done=_done/10
	let _left=40-$_done
	_process=${3}

	_fill=$(printf "%${_done}s")
	_empty=$(printf "%${_left}s")

	#printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%% ${_process}"
	printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%% ${_process}"
}

function question {

	if [ ${YES_TO_ALL} -eq 1 ]
	then
		return 1
	fi

	QUESTION=": "
	if [ ! -z "$1" ]
	then
		QUESTION="$1${QUESTION}"
	fi

	read -r -p "${QUESTION}" INPUT

	#if [[ ! INPUT =~ ^[Yy]$ ]]
	if [[ $INPUT =~ [Yy]$ ]]
	then
		return 1
	else
		return 0
	fi
}

function createOrAppendFile {
	FILE=$1
	TEXT=$2

	if [ ! -f ${FILE} ]; then
		touch ${FILE}
		printf "%s" "${TEXT}" > ${FILE}
		return 1
	else
		if ! grep -Fxq "${TEXT}" ${FILE}
		then
			printf "%s" "${TEXT}" >> ${FILE}
			return 2
		fi
	fi

	return 0
}

function installApt {
	PACKAGES=""

	while [[ $# -gt 0 ]]
	do
		PACKAGES="${PACKAGES} $1"
		shift # past argument or value
	done

	#printf "Updating packages list\n"

	#sudo apt-get update -qq -y

	printf "Installing packages: ${PACKAGES}\n"

	sudo apt-get install -qq -y -f ${PACKAGES}
}

function uninstallApt {
	PACKAGES=""

	while [[ $# -gt 0 ]]
	do
		PACKAGES="${PACKAGES} $1"
		shift # past argument or value
	done

	printf "Uninstalling packages: ${PACKAGES}\n"

	sudo apt-get remove --purge -qq -y -f ${PACKAGES}
	sudo apt-get -qq -y autoremove
	sudo apt-get -qq -y autoclean
}
