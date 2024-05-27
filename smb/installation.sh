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
    debian*|ubuntu*)
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install  samba       
        # firewall stuff
        # sudo apt install ufw -y
        # sudo ufw enable
        # sudo ufw allow from 192.168.1.0/24 to any port nfs
        # sudo ufw reload
        ;;
esac
