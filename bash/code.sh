#!/bin/bash

# lxc launch images:debian/11 db11code
# lxc config device add db11code port8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8080

apt update && apt upgrade -y
apt install -y nano htop curl gnupg unzip
curl -fOL https://github.com/coder/code-server/releases/download/v4.0.2/code-server_4.0.2_amd64.deb
dpkg -i code-server_4.0.2_amd64.deb

sudo systemctl enable --now code-server@$USER
curl localhost:8080
ip a
systemctl status code-server@$USER
curl localhost
curl localhost:8080
cat .config/code-server/config.yaml
