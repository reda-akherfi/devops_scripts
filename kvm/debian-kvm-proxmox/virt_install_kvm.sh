#!/usr/bin/env bash

VMNAME=deepspace
DOMAIN=reda-boss
NETWORK=default
OSVARIANT=debian12
# source the colors script
# create the prompting function

virt-install --connect=qemu:///system --name=${VMNAME} --ram=1024 --vcpus=2 \
    --disk path=/var/lib/libvirt/images/${VMNAME}.qcow2,size=8,bus=virtio,format=qcow2 \
    --initrd-inject=/var/lib/libvirt/images/preseeds/bookworm/preseed.cfg \
    --location http://ftp.de.debian.org/debian/dists/bookworm/main/installer-amd64 \
    --graphics none \
    --os-variant ${OSVARIANT}  --network network=default \
    --extra-args="auto=true hostname="${VMNAME}" domain="${DOMAIN}.local" console=tty0 console=ttyS0,115200n8 serial";
