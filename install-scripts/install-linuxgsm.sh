#!/bin/bash

#download linuxgsm
echo "download linuxgsm"
curl -Lo linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh mcserver

#install linuxgsm
echo "install linuxgsm"
./mcserver install
