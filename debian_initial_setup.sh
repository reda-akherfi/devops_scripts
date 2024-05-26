#!/usr/bin/env bash


# run as root
apt update -y
apt upgrade -y

apt install vim sudo tree 

usermod -aG sudo reda



