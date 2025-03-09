#!/bin/bash

modpack_name="v4.5_SERVER_TAD"
echo "download ANCIENT DAWN"
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

#remove client-only mods
rm serverfiles/mods/sodiumextras-forge-1.0.7-1.20.1.jar