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
        sudo systemctl enable --now nfs-kernel-server
        # making the share/export
        sudo mkdir -p /home/reda/breen
        sudo chown nobody:nogroup /home/reda/breen
        sudo chmod 755 /home/reda/breen
        sudo echo "/home/reda/breen 192.168.1.0/24(rw,sync,no_subtree_check)" >> /etc/exports
        sudo exportfs -a
        # firewall stuff
        sudo apt install ufw -y
        sudo ufw enable
        sudo ufw allow from 192.168.1.0/24 to any port nfs
        sudo ufw reload
        ;;
esac
