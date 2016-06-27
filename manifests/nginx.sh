#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CURRENT_DIR}/../common/base.sh"

###
# Variables
###

WITH_FACILITY=0

NGINX_ROUTE_DIR="/etc/nginx/sites-available"
NGINX_ROUTE_LINK_DIR="/etc/nginx/sites-enabled"

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
"
}

function _install {
	printf "Installing nginx\n"
	installApt nginx

#	if [ ! ${WITH_FACILITY} -eq 0 ]
#	then
#		sudo mkdir -p /etc/nginx/configs
#		cd "${CURRENT_DIR}"
#		sudo cp -r nginx/configs/*.conf /etc/nginx/configs/
#		sudo cp -r nginx/sites/* "${NGINX_ROUTE_DIR}"
#		sudo ln -s "${NGINX_ROUTE_DIR}/facility" "${NGINX_ROUTE_LINK_DIR}"
#		cd "${EXEC_DIR}"
#		sudo service nginx reload
#	fi

	printf "Nginx installed\n"
}


function _uninstall {
	printf "Uninstalling nginx\n"
	uninstallApt nginx
#	sudo apt-get remove -qq -y -f nginx
#	sudo rm -r /etc/nginx/configs
#	sudo rm /etc/nginx/sites-enabled/facility
#	sudo rm /etc/nginx/sites-available/facility
	printf "Nginx removed\n"
}

case ${PROCESS} in
	install)
		_install
	;;
	uninstall)
		_uninstall
	;;
	*)
		_help
	;;
esac