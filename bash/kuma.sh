#!/bin/bash

apt update && apt upgrade -y
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt update
apt install nodejs -y

#check node and npm
node -v; npm -v
npm install pm2 -g

curl -o kuma_install.sh http://git.kuma.pet/install.sh && sh kuma_install.sh

cd /opt/uptime-kuma/ && pm2 start server/server.js --name uptime-kuma -- --port=80 --host=0.0.0.0

pm2 save && pm2 startup
reboot