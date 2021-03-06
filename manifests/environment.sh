#!/usr/bin/env bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../common/base.sh" CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

	printf "Configuring UTC timezone\n"
	sudo timedatectl set-timezone UTC

	installApt ntp
}

function _update {
	printf "update\n"
}

function _uninstall {
	printf "uninstall\n"
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