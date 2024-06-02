#!/usr/bin/env bash

set -xe

DISKANME="april_mein"
DISKSIZE="10G"
DISKTYPE="qcow2"
if [[ "$DISKTYP" == "qcow2" ]];then
    EXTENSION="qcow2";
fi

sudo qemu-img create -o preallocation=metadata \
    -f qcow2 /var/lib/libvirt/images/${DISKANME}.${EXTENSION} ${DISKSIZE}

