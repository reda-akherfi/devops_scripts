#!/usr/bin/env bash

set -xe

VMNAME="april"
OSVARIANT="fedora40"
PATHDISK="/var/lib/libvirt/images/april_mein.qcow2"
PATHCDROM="/home/reda/torrents/complete/Fedora-Server-dvd-x86_64-40/Fedora-Server-dvd-x86_64-40-1.14.iso"
# graphics either spice or  console
GRAPHICS="spice"
# opts are: bridge; default; both
NETWORK="both"
# cdrom or location
CDROM_LOCATION="location"
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
    GRAPHICS="none --console pty,target_type=serial --extra-args 'console=ttyS0,115200n8 serial'"
fi
if [[ "$CDROM_LOCATION" == "location" ]];then
    CDROM_LOCATION="--location";
    # PATHCDROM stays the same
elif [[ "$CDROM_LOCATION" == "console" ]];then
    CDROM_LOCATION="--console";
fi



sudo virt-install --connect qemu:///system                                               \
    --name $VMNAME  --os-variant $OSVARIANT                                               \
    --cpu  mode=host-passthrough --vcpus maxvcpus=7,vcpus=1                              \
    --memory memory=2048,currentMemory=2048                                               \
    --disk $PATHDISK                                                                     \
    --network $NETWORK                                                                \
    ${CDROM_LOCATION} $PATHCDROM                                                                   \
    --graphics $GRAPHICS                                                                     \
    --boot uefi
