#!/bin/bash

# Log in to Proxmox
curl -c cookies.txt -d "username=myusername&password=mypassword" https://myproxmoxip:8006/api2/json/access/ticket > /dev/null

# Check for updates
update_status=$(curl -b cookies.txt https://myproxmoxip:8006/api2/json/cluster/status | jq -r '.data[].updates')

if [[ $update_status == "0" ]]; then
  echo "No updates available"
  exit 0
fi

# Download updates
echo "Downloading updates..."
curl -b cookies.txt -o updates.tgz https://myproxmoxip:8006/api2/json/cluster/apt/update

# Install updates
echo "Installing updates..."
curl -b cookies.txt -X POST https://myproxmoxip:8006/api2/json/cluster/apt/dist-upgrade

# Reboot nodes
echo "Rebooting nodes..."
curl -b cookies.txt -X POST https://myproxmoxip:8006/api2/json/cluster/reboot

# Wait for nodes to come back online
echo "Waiting for nodes to come back online..."
sleep 300

# Confirm update status
update_status=$(curl -b cookies.txt https://myproxmoxip:8006/api2/json/cluster/status | jq -r '.data[].updates')

if [[ $update_status == "0" ]]; then
  echo "Updates installed successfully"
else
  echo "Error installing updates"
fi

# Log out of Proxmox
curl -b cookies.txt -X DELETE https://myproxmoxip:8006/api2/json/access/ticket > /dev/null
rm cookies.txt
