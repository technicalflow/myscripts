#!/bin/bash

# lxc launch images:debian/11 db11plex -p macvlan
# lxc config device add db11plex music disk source=/data/dane/Music/ path=/data/Muzyka
# lxc config device add db11plex movie disk source=/data/dane/Filmy path=/data/Filmy

apt update && apt upgrade -y
apt install -y nano htop curl gnupg ufw

echo deb https://downloads.plex.tv/repo/deb public main | tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
# curl https://downloads.plex.tv/plex-keys/PlexSign.key > plexsign.key
# apt-key add plexsign.key

apt update && apt install plexmediaserver
# rm plexsign.key

touch /etc/ufw/applications.d/plexmediaserver
cat << EOFplex > /etc/ufw/applications.d/plexmediaserver
[plexmediaserver]
title=Plex Media Server (Standard)
description=The Plex Media Server
ports=32400/tcp|3005/tcp|5353/udp|8324/tcp|32410:32414/udp

[plexmediaserver-dlna]
title=Plex Media Server (DLNA)
description=The Plex Media Server (additional DLNA capability only)
ports=1900/udp|32469/tcp

[plexmediaserver-all]
title=Plex Media Server (Standard + DLNA)
description=The Plex Media Server (with additional DLNA capability)
ports=32400/tcp|3005/tcp|5353/udp|8324/tcp|32410:32414/udp|1900/udp|32469/tcp
EOFplex

systemctl status plex*

netstat -lnpt | grep Plex
ufw status verbose
ufw allow ssh
ufw allow plexmediaserver
ufw status verbose
ufw enable
ufw status verbose

# go to serverip:32400/web