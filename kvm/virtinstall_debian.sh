#!/usr/bin/env bash



sudo virt-install    --connect qemu:///system --name debian-script-02     --memory memory=1024,currentMemory=512         --vcpus maxvcpus=7,vcpus=1                     --cpu   mode=host-passthrough                --network  network=default       --location /var/lib/libvirt/isos/debian-12.5.0-amd64-DVD-1.iso        --os-variant debian12                 --disk size=5,format=qcow2,cache=none,discard=unmap        --tpm default       --channel type=unix,target.type=virtio,target.name=org.qemu.guest_agent.0      --graphics none     --extra-args 'console=tty0 console=ttyS0,115200n8 --- console console=tty0 console=ttyS0,115200n8'     --boot uefi 


