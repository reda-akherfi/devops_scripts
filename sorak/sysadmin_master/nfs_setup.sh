#!/usr/bin/env bash

set -e

# Without accurate clocks on all nodes, NFS can introduce unwanted delays.
clear
echo -e "setting up the time"
sudo timedatectl set-ntp true
timedatectl
sleep 2
clear
# Both client and server only require the installation of the nfs-utils package.
echo -e "installing the nfs-utils"
sudo pacman -S nfs-utils
clear

# add your exports in /etc/exports
# maybe change /etc/nfs.conf a bit
# modify /etc/fstab to include the disk
# what the hell am I supposed to do with perms
#
