#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "{$CURRENT_DIR}/../common/base.sh"

	###
	# Variables
	###

	###
	# Input checker
	###

while [[ $# -gt 0 ]]
do
	key="$1"
	case $key in
		-h | --help)
			PROCESS="help"
		;;
		-i | --install)
			PROCESS="install"
		;;
		-d | --dir)
			INSTALL_DIR="$2"
			shift
		;;
		-u | --update)
			PROCESS="update"
		;;
		-un | --uninstall)
			PROCESS="uninstall"
		;;
		*)
		# unknown option
		;;
	esac
	shift # past argument or value
done

###
# Script
###

function _help {
	printf "No process was initiated.
  -i, --install		Install
  -u, --update		Update
  --uninstall		Uninstall
  -h, --help		Display this help and exit
"
}

function _install {
	printf "install\n"

	installApt git
}

function _update {
	printf "update\n"
}

function _uninstall {
	printf "uninstall\n"
	sudo apt-get remove git
	sudo apt-get autoremove
	sudo apt-get autoclean
}

case ${PROCESS} in
	install)
		_install
	;;
	update)
		_update
	;;
	uninstall)
		_uninstall
	;;
	*)
		_help
	;;
esac