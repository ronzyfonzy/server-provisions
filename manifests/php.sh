#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CURRENT_DIR}/../common/base.sh"

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

	installApt php5-fpm php5-cli php5-mysql php5-curl php5-intl php-pear php5-mcrypt php5-memcached

	sudo service php5-fpm restart
}

function _update {
	printf "update\n"
}

function _uninstall {
	printf "uninstall\n"

	uninstallApt php5-*
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