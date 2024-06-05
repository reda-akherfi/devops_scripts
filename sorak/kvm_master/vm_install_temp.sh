#!/usr/bin/env bash

set -xe

VMNAME="kiraarch"
OSVARIANT="archlinux"
PATHDISK="/var/lib/libvirt/images/kiraarch.qcow2"
PATHCDROM="/home/reda/torrents/complete/archlinux-2024.05.01-x86_64.iso"
# graphics either spice or  console
GRAPHICS="spice"
EXTRA_ARGS=
EXTRA_ARGS_EXTRA=
# opts are: bridge; default; both
NETWORK="bridge"
# cdrom or location
CDROM_LOCATION="cdrom"
if [[ "$NETWORK" == "bridge" ]];then
    NETWORK=" bridge=golden";
elif [[ "$NETWORK" == "default" ]];then
    NETWORK=" network=default";
else
    NETWORK=" network=default --network bridge=golden";
fi
if [[ "$GRAPHICS" == "spice" ]];then
    GRAPHICS="spice --channel type=unix,target.type=virtio,target.name=org.qemu.guest_agent.0";
elif [[ "$GRAPHICS" == "console" ]];then
    GRAPHICS="none";
    EXTRA_ARGS_EXTRA="--extra-args"
    EXTRA_ARGS="console=tty0 console=ttyS0,115200n8 --- console console=tty0 console=ttyS0,115200n8";
fi
if [[ "$CDROM_LOCATION" == "location" ]];then
    # PATHCDROM stays the same
    CDROM_LOCATION="--location";
elif [[ "$CDROM_LOCATION" == "cdrom" ]];then
    CDROM_LOCATION="--cdrom";
fi



sudo virt-install --connect qemu:///system                                               \
    --name "$VMNAME"  --os-variant "$OSVARIANT"                                               \
    --cpu  mode=host-passthrough --vcpus maxvcpus=7,vcpus=1                              \
    --memory memory=2048,currentMemory=2048                                               \
    --disk "$PATHDISK"                                                                     \
    --network $NETWORK                                                                \
    ${CDROM_LOCATION} "$PATHCDROM"                                                                   \
    --graphics $GRAPHICS                                           \
    --boot uefi

# $EXTRA_ARGS_EXTRA "$EXTRA_ARGS"
