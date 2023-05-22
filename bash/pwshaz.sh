#!/bin/bash

apt update && apt upgrade -y
apt install -y dialog htop curl wget openssl git gnupg
apt install -y wget apt-transport-https software-properties-common

#SSH
systemctl enable --now sshd
usermod -aG ssh,users madmin

#Powershell and Azure Cli
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb 
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb
apt update && apt install -y powershell azure-cli

#Install Powershell modules
pwsh -c 'update-module -Force'
pwsh -c 'install-module Az -Force'

#terraform 
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install -y terraform 
