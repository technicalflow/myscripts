#!/bin/bash

# lxc launch images:ubuntu/bionic/cloud ub18code -p default -p cloudinit
# lxc config device add ub18code port8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8080

apt update && apt upgrade -y
apt install -y nano htop curl gnupg unzip
#curl -fsSL https://code-server.dev/install.sh | sh

version="$(curl -fsSL https://api.github.com/repos/coder/code-server/releases | awk 'match($0,/.*"html_url": "(.*\/releases\/tag\/.*)".*/)' | head -n 1 | awk -F '"' '{print $4}')"
version="${version#https://github.com/coder/code-server/releases/tag/}"
version="${version#v}"

curl -fOL https://github.com/coder/code-server/releases/download/v${version}/code-server_${version}_amd64.deb
dpkg -i code-server_${version}_amd64.deb
rm code-server_${version}_amd64.deb

systemctl enable --now code-server@$USER
systemctl status code-server@$USER

curl -s localhost:8080

#check and modify password
cat .config/code-server/config.yaml