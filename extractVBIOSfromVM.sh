#!/bin/bash

# Get the ID of the virtual machine
VM_ID=$(virsh list --all | grep "your_vm_name" | awk '{print $1}')

# Get the PCI address of the virtual graphics card
PCI_ADDRESS=$(virsh dumpxml $VM_ID | grep -A 2 'model type=' | grep -oP '(?<=address\ slot=\")[^\"]*(?=\")')

# Extract the video BIOS from the virtual graphics card
echo "Video BIOS for VM $VM_ID:"
sudo qemu-img info "pci-assign:$PCI_ADDRESS" | grep "romfile" | cut -d "'" -f 2
