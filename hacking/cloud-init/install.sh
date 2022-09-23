#!/bin/bash

set -Eeuo pipefail

virsh destroy database || true
virsh undefine database || true
rm -rf /var/lib/libvirt/images/database

mkdir -p /var/lib/libvirt/images/base-images /var/lib/libvirt/images/database

if [ ! -f /var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2 ]; then
  curl -Lo /var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2 https://download.fedoraproject.org/pub/fedora/linux/releases/36/Cloud/x86_64/images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2
fi

# dnf install -y cloud-utils genisoimage
cloud-localds /var/lib/libvirt/images/database/cloud-init.iso user-data.yaml

virt-install --name database --autostart --noautoconsole --cpu host-passthrough \
             --vcpus 2 --ram 4096 --os-variant fedora36 \
             --disk path=/var/lib/libvirt/images/database/database.qcow2,backing_store=/var/lib/libvirt/images/base-images/Fedora-Cloud-Base-36-1.5.x86_64.qcow2,size=20 \
             --network network=default \
             --console pty,target.type=virtio --serial pty --import \
             --disk path=/var/lib/libvirt/images/database/cloud-init.iso,readonly=on \
             --sysinfo system.serial=ds=nocloud

virsh console database

