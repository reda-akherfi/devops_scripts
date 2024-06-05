#!/usr/bin/env bash

set -xe

DISKANME="kiraarch"
DISKSIZE="15G"
DISKTYPE="qcow2"
if [[ "$DISKTYPE" == "qcow2" ]];then
    EXTENSION="qcow2";
fi

sudo qemu-img create -o preallocation=metadata \
    -f qcow2 /var/lib/libvirt/images/"${DISKANME}"."${EXTENSION}" "${DISKSIZE}"

