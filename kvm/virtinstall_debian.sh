#!/usr/bin/env bash

virsh destroy --domain archer
virsh undefine --nvram archer
rm /var/lib/libvirt/images/archer*


sudo virt-install    --connect qemu:///system --name archer   --disk size=20,format=qcow2,cache=none,discard=unmap      --memory memory=1024,currentMemory=1024         --vcpus maxvcpus=7,vcpus=1                     --cpu   mode=host-passthrough                --network  network=default  --cdrom /var/lib/libvirt/isos/archlinux-2024.05.01-x86_64.iso    --os-variant archlinux            --tpm default       --channel type=unix,target.type=virtio,target.name=org.qemu.guest_agent.0      --graphics spice    --boot uefi 

sleep 5
virt-viewer --connect=$(virsh uri) --attach archer
