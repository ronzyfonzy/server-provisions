#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${CURRENT_DIR}/../common/base.sh"

	###
	# Variables
	###

INSTALL_DIR="/usr/share/adminer"

PROCESS=""
OWNER="vagrant:www-data"

INDEX_PHP_STRING="<?php
function adminer_object() {
	// required to run any plugin
	include_once \"./plugins/plugin.php\";

	// autoloadervi
	foreach (glob(\"plugins/*.php\") as \$filename) {
		include_once \"./\$filename\";
	}

	return new AdminerPlugin(\$plugins);
}

// include original Adminer or Adminer Editor
include \"./adminer.php\";"

NGINX_ROUTE_FILE="/etc/nginx/sites-available/adminer"
NGINX_ROUTE_LINK_FILE="/etc/nginx/sites-enabled/adminer"
NGINX_ROUTE_FILE_STRING="server {
	listen   90;
	server_name adminer.loc 127.0.0.1;

	index index.php;
	root /usr/share/adminer;

	client_max_body_size 2000M;

	location / {
	try_files \$uri \$uri/ =404;
	}

	location ~ \.php\$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)\$;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_read_timeout 300;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}"

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
		-y)
			YES_TO_ALL=1
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
  -i, --install      Install Adminer
  -u, --update		Update Adminer
  --uninstall		Uninstall Adminer
  -d, --dir		Adminer install or uninstall directory
  			(default '/usr/share/adminer')
  -y		Assume Yes to all queries and do not prompt
  -h, --help		Display this help and exit
"
}

function installQuestion {
	return $(question "Do you want to install Adminer in '${INSTALL_DIR}'")
}

function uninstallQuestion {
	return $(question "Uninstall Adminer from '${INSTALL_DIR}'")
}

function installApplication {
	printf "Creating directories\n"
	sudo mkdir -p "${INSTALL_DIR}/plugins"

	printf "Downloading files\n"

	ProgressBar 0 100
	wget -q -O "${INSTALL_DIR}/adminer.php" http://www.adminer.org/latest-mysql-en.php

	ProgressBar 25 100
	wget -q -O "${INSTALL_DIR}/adminer.css" https://raw.githubusercontent.com/vrana/adminer/master/designs/bueltge/adminer.css

	ProgressBar 50 100
	wget -q -O "${INSTALL_DIR}/plugins/plugin.php" https://raw.githubusercontent.com/vrana/adminer/master/plugins/plugin.php

	ProgressBar 75 100
	wget -q -O "${INSTALL_DIR}/plugins/tables-filter.php" https://raw.githubusercontent.com/vrana/adminer/master/plugins/tables-filter.php

	ProgressBar 100 100

	printf "Setting up\n"

	sed -i -e 's/?"utf8mb4":"utf8"/?"utf8":"utf8"/g' "${INSTALL_DIR}/adminer.php"

	createOrAppendFile "${INSTALL_DIR}/index.php" "${INDEX_PHP_STRING}"

	sudo chown -R ${OWNER} ${INSTALL_DIR}

	printf "Application installed\n"
}

function setupNginx {
	printf "Setting up nginx\n"

	createOrAppendFile "${NGINX_ROUTE_FILE}" "${NGINX_ROUTE_FILE_STRING}"

	case "$?" in
		1) # Created
			sudo ln -s "${NGINX_ROUTE_FILE}" "${NGINX_ROUTE_LINK_FILE}"
			sudo service nginx reload
		;;
	esac

	printf "Nginx set\n"
}

function _install {
	if ! installQuestion
	then
		if [ ! -f "${INSTALL_DIR}/index.php" ]; then
			installApplication
			setupNginx
		else
			printf "Adminer already installed\n"
		fi
	else
		printf "Installation cancelled\n"
	fi
}

function _update {
	printf "update"
}

function _uninstall {
	if ! uninstallQuestion
	then
		if [ -d ${INSTALL_DIR} ]; then
			sudo rm -r ${INSTALL_DIR}
			sudo rm ${NGINX_ROUTE_LINK_FILE}
			sudo rm ${NGINX_ROUTE_FILE}
			printf "Adminer successfuly uninstalled from '${INSTALL_DIR}'\n"
		else
			printf "Adminer not present in '${INSTALL_DIR}'\n"
		fi
	else
		printf "Uninstall cancelled\n"
	fi
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