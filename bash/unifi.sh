#!/bin/bash

apt-get update && apt-get upgrade -y
apt-get install ca-certificates apt-transport-https nano htop wget gnupg
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list
# apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg
apt-get update && apt-get install unifi -y

systemctl status unifi
nano /usr/lib/unifi/data/system.properties
nano /etc/init.d/unifi

systemctl restart unifi
systemctl status unifi
java version

#Logs
cat /var/log/unifi/server.log

# IP:8080
# IP:8443