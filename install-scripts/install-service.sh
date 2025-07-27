#!/bin/bash

# doesn't matter if it already exists, just always overwrite and reload
SERVICE_FILE="/etc/systemd/system/mcserver.service"

echo "[Unit]
Description=Minecraft Server
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
User=mcserver
#Assume that the service is running after main process exits with code 0
RemainAfterExit=yes
ExecStart=/home/mcserver/mcserver start
ExecStop=/home/mcserver/mcserver stop
Restart=no
WorkingDirectory=/home/mcserver

[Install]
WantedBy=multi-user.target" > $SERVICE_FILE

chmod 644 $SERVICE_FILE

systemctl daemon-reload
systemctl enable mcserver
systemctl start mcserver
