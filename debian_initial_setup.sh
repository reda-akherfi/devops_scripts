#!/usr/bin/env bash

# the /etc/sources.list file
# XXX remove the CD rom one
# deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
# deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware non-free
# deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware non-free
########################################

# run as root
apt update -y
apt upgrade -y

apt install vim sudo tree 

usermod -aG sudo reda



