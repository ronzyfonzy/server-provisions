#!/usr/bin/env bash

PROVISION_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${PROVISION_DIR}/../common/base.sh"

	###
	# Variables
	###

MANIFESTS=("nginx" "php" "nodejs" "mysql" "adminer")

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
	ALL_MANIFESTS=""
	for ix in ${!MANIFESTS[*]}
	do
		ALL_MANIFESTS="${ALL_MANIFESTS}\n- ${MANIFESTS[$ix]}"
	done

	printf "This provisioning script will install the following manifests scripts:${ALL_MANIFESTS}

No process was initiated.
  -i, --install		Install
  -u, --update		Update
  --uninstall		Uninstall
  -h, --help		Display this help and exit
"
}

function _install {
	printf "install\n"

	printf "Updating packages list\n"

	sudo apt-get update -qq -y

	for ix in ${!MANIFESTS[*]}
	do
		source ${PROVISION_DIR}/../manifests/${MANIFESTS[$ix]}.sh -i -y
	done
}

function _update {
	printf "update\n"
}

function _uninstall {
	printf "uninstall\n"

	for ix in ${!MANIFESTS[*]}
	do
		source ${PROVISION_DIR}/../manifests/${MANIFESTS[$ix]}.sh --uninstall -y
	done
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