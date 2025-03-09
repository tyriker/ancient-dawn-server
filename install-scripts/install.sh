#!/bin/bash

#check if sudo
echo "checking sudo"
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi
echo "sudo good"

#add mcserver user
echo "check if mcserver exists"
if id "mcserver" &>/dev/null; then
    echo "User 'mcserver' exists."
else
    echo "adding mcserver"
    useradd -m mcserver
    usermod -aG sudo mcserver
fi

#install deps
echo "installing deps"

# Update package lists
apt update
# Install curl
apt install -y curl
apt install -y bc binutils bsdmainutils distro-info jq lib32gcc-s1 lib32stdc++6 netcat-openbsd openjdk-17-jre pigz tmux unzip uuid-runtime

#switch to mcserver
echo "install into mcserver"
current_dir=$(pwd)
cd /home/mcserver
cp ${current_dir}/install-linuxgsm.sh .
sudo -u mcserver ./install-linuxgsm.sh
rm install-linuxgsm.sh
chown -R mcserver:mcserver /home/mcserver
cd "${current_dir}"

echo "it was a pleasure"
exit 0