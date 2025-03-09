#!/bin/bash

current_dir=$(pwd)

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
apt install -y curl rsync
apt install -y bc binutils bsdmainutils distro-info jq lib32gcc-s1 lib32stdc++6 netcat-openbsd openjdk-17-jre pigz tmux unzip uuid-runtime

#install mcserver
echo "install into mcserver"
cd /home/mcserver
cp ${current_dir}/install-linuxgsm.sh .
sudo -u mcserver ./install-linuxgsm.sh
rm install-linuxgsm.sh
echo "copy server files"
rsync -a --remove-source-files ${current_dir}/server-files/ /home/mcserver
#chown newly moved files
chown -R mcserver:mcserver /home/mcserver
cd ${current_dir}

#install modpack
echo "install modpack"
cd /home/mcserver
cp ${current_dir}/install-modpack.sh .
sudo -u mcserver ./install-modpack.sh
rm install-modpack.sh
cd ${current_dir}

#install local java
echo "Setup local Java"
cd /home/mcserver
cp ${current_dir}/install-java.sh .
sudo -u mcserver ./install-java.sh
rm install-java.sh
cd ${current_dir}

#chown everything in home
chown -R mcserver:mcserver /home/mcserver

echo "Run vanilla once"
cd /home/mcserver
sudo -u mcserver ./mcserver start
sudo -u mcserver ./mcserver stop
cd ${current_dir}

echo "Patching in Forge"
cd /home/mcserver/serverfiles
java/jdk-21.0.6+7/bin/java -jar forge-1.20.1-47.4.0-installer.jar --installServer
mv -f user_jvm_args-forge.txt user_jvm_args.txt
cd /home/mcserver/lgsm/config-lgsm/mcserver
mv -f mcserver-modpack.cfg mcserver.cfg
cd ${current_dir}

#chown everything in home one final time
chown -R mcserver:mcserver /home/mcserver
cd ${current_dir}

echo "it was a pleasure"
exit 0