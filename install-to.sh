#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Error: Exactly one argument is required."
  echo "Pass your SSH hostname in as argument"
  exit 1
fi

remote_host=$1

echo "copy installs to ${remote_host}"
scp install-scripts/* "${remote_host}":

echo "execute installs on ${remote_host}"
ssh -t $remote_host "sudo stdbuf -oL -eL bash ./install.sh"

echo "delete installs on ${remote_host}"
ssh $remote_host "rm install.sh install-linuxgsm.sh"

echo "exit with great success"
exit 0