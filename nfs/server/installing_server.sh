#!/usr/bin/env bash
#

# what is the distro
if [ -f /etc/os-release ];then
	. /etc/os-release
	DISTRO=$ID
	echo $DISTRO
else
	echo "Cannot determine the Linux distro"
	exit 1
fi


