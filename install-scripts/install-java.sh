#!/bin/bash

jdk_name=microsoft-jdk-21-linux-x64.tar.gz
mkdir -p serverfiles/java
if [ -f "${jdk_name}" ]; then
    echo "Download already exists."
else
    curl -OL https://aka.ms/download-jdk/${jdk_name}
fi
tar -xzf ${jdk_name} -C serverfiles/java
