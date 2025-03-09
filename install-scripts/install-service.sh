#!/bin/bash

if systemctl list-unit-files | grep -q '^mcserver\.service'; then
    echo "mcserver service already exists."
else
    SERVICE_FILE="/etc/systemd/system/mcserver.service"

    echo "[Unit]
    Description=Minecraft Server
    After=network.target

    [Service]
    User=mcserver
    ExecStart=/home/mcserver/mcserver start
    Restart=always
    WorkingDirectory=/home/mcserver
    StandardOutput=inherit
    StandardError=inherit

    [Install]
    WantedBy=multi-user.target" > $SERVICE_FILE

    chmod 644 $SERVICE_FILE
    systemctl daemon-reload
fi

systemctl enable mcserver
systemctl start mcserver