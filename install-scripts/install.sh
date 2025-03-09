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
apt install -y curl rsync
apt install -y bc binutils bsdmainutils distro-info jq lib32gcc-s1 lib32stdc++6 netcat-openbsd openjdk-17-jre pigz tmux unzip uuid-runtime

#switch to mcserver
echo "install into mcserver"
current_dir=$(pwd)
cd /home/mcserver
cp ${current_dir}/install-linuxgsm.sh .
sudo -u mcserver ./install-linuxgsm.sh
rm install-linuxgsm.sh
echo "copy server files"
rsync -a --remove-source-files ${current_dir}/server-files/ /home/mcserver

modpack_name="v4.5_SERVER_TAD"
echo "download ANCIENT DAWN!!!"
if [ -f "${modpack_name}.zip" ]; then
    echo "Download already exists."
else
    curl -Lo ${modpack_name}.zip 'https://mediafilez.forgecdn.net/files/6282/758/v4.5_SERVER_TAD.zip' \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
    -H 'accept-language: en-US,en;q=0.9' \
    -H 'cache-control: no-cache' \
    -H 'dnt: 1' \
    -H 'pragma: no-cache' \
    -H 'priority: u=0, i' \
    -H 'referer: https://www.curseforge.com/' \
    -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'sec-ch-ua-platform: "macOS"' \
    -H 'sec-fetch-dest: document' \
    -H 'sec-fetch-mode: navigate' \
    -H 'sec-fetch-site: cross-site' \
    -H 'sec-fetch-user: ?1' \
    -H 'upgrade-insecure-requests: 1' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36'
fi
unzip ${modpack_name}
rsync -a --remove-source-files "Server TAD"/* serverfiles
rm -r "Server TAD"

echo "Patching in Forge"
cd serverfiles
java -jar forge-1.20.1-47.4.0-installer.jar --install-server

chown -R mcserver:mcserver /home/mcserver
cd "${current_dir}"

echo "it was a pleasure"
exit 0