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

case $DISTRO in
    debian)
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install nfs-kernel-server -y
        ;;
esac
