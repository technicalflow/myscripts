#!/bin/bash

# lxc config device add db11code backup disk source=/data/tm path=/data

apt install -y samba samba-common htop nano curl gnupg mc avahi-utils
nano /etc/samba/smb.conf

[global]
workgroup               = WORKGROUP
netbios name            = TIMECAPSULE
security                = user
passdb backend          = tdbsam
smb ports               = 445
log level               = 1

# disable things we don't need
server role             = standalone
server services         = -dns, -nbt
load printers           = no
#printing                = bsd
#printcap name           = /dev/null
disable spoolss         = yes
disable netbios         = yes

# Time Machine
durable handles             = yes
ea support                  = yes
fruit:aapl                  = yes
fruit:advertise_fullsync    = true
fruit:time machine          = yes
kernel oplocks              = no
kernel share modes          = no
map acl inherit             = yes
posix locking               = no
smb2 leases                 = yes
vfs objects                 = catia fruit streams_xattr
spotlight                   = yes
# Security
client ipc max protocol = default
client max protocol     = default
server max protocol     = SMB3
client ipc min protocol = default
client min protocol     = CORE
server min protocol     = SMB2

[data]
browseable              = Yes
comment                 = Apple TimeMachine Backup Target
inherit acls            = Yes
path                    = /data
read only               = No
valid users             = @timemachine_users
writable                = yes

# vi:syntax=samba


id
systemctl restart smbd
systemctl status smbd
groupadd timemachine_users
useradd -M -G timemachine_users timemachine
smbpasswd -a timemachine
chown -R timemachine:timemachine_users /data/

nano /data/.com.apple.TimeMachine.quota.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>GlobalQuota</key>
    <integer>1000000</integer>
  </dict>
</plist>

nano /etc/avahi/services/timemachine.service
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
        <name replace-wildcards="yes">Time Capsule on %h</name>
        <service>
                <type>_adisk._tcp</type>
                <txt-record>sys=waMa=0,adVF=0x100</txt-record>
                <txt-record>dk0=adVN=data,adVF=0x82</txt-record>
        </service>
        <service>
                <type>_smb._tcp</type>
                <port>10445</port>
        </service>
        <service>
                <type>_device-info._tcp</type>
                <port>0</port>
                <txt-record>model=TimeCapsule6</txt-record>
        </service>
</service-group>

systemctl restart avahi*
systemctl status avahi*
systemctl restart smbd
systemctl status smbd


#Share config
Based on the excellent answer of ph0t0nix, I propose the following step-by-step approach for my Ubuntu 18.04 server:
In host determine UID of owner of rootfs:

sudo ls -l /var/lib/lxd/storage-pools/lxd/containers/webserver/rootfs  
id -u root   → 100000

In container determine UID of ubuntu (i.e. user in container):
id -u ubuntu   → 1000

Create shared folder in host and add it to container:
lxc config device add webserver mydevicename disk path=/home/share_on_guest source=/home/share_on_host

Adjust in host UID of shared folder (UID = UID host + UID guest):
sudo chown 101000:101000 /home/share_on_host

Guest (user ubuntu) has now access to shared folder and can adjust within container access to shared folder using chmod.
