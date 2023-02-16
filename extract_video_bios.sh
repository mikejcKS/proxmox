#!/bin/bash

# Get the device address of the video card
DEVICE_ADDR=$(lspci | grep VGA | awk '{print $1}')

# Get the domain and bus number of the device
DOMAIN=$(echo $DEVICE_ADDR | cut -d ':' -f 1)
BUS=$(echo $DEVICE_ADDR | cut -d ':' -f 2)

# Extract the video BIOS data
sudo qemu-kvm -device pci-assign,host=$DEVICE_ADDR -dump-bios -bios-size 64k -bios video_bios.bin

# Print the extracted BIOS data
hexdump -C video_bios.bin
