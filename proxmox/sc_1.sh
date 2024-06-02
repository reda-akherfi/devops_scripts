#!/usr/bin/env bash

# remove all enterprise repos and update the server
rm -f /etc/apt/sources.list.d/{ceph.list,pve-enterprise.list}
apt update && apt full-upgrade
apt install vim tmux tree 

# set the console font to setfont  /usr/share/consolefonts/Uni2-TerminusBold24x12.psf.gz

# set the consoleblank kernel parameter in the grub config



