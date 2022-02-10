#!/bin/bash
set -e
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

## This is a simple script to compile and run airplay on Raspberry Pi Zero
## Remember to set gpu_mem=256 in /boot/config.txt
## and for best setting set HDMI_mode=1 and HDMI_group=4 to set 720p@60Hz in /boot/config.txt

## git clone https://github.com/FD-/RPiPlay.git
## cd RPiPlay

apt-get install-y curl cmake libavahi-compat-libdnssd-dev libplist-dev libssl-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-libav \
    gstreamer1.0-vaapi gstreamer1.0-plugins-bad

curl -L --output /tmp/rpiplay.zip https://codeload.github.com/FD-/RPiPlay/zip/refs/heads/master
unzip /tmp/rpiplay.zip -d /tmp/play
cd /tmp/play

mkdir -p build 
cd build
cmake --DCMAKE_CXX_FLAGS="-O3" --DCMAKE_C_FLAGS="-O3" ..
# Compile - can take up to 30min on Pi Zero
make -j 2

chmod +x rpiplay
cp ./rpiplay /usr/bin/

cat << EOFrpi > /lib/systemd/system/rpiplay.service
[Unit]
Description=rpiplay (AirPlay for Raspberry Pi)
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/rpiplay -n homeair -b on -l -a hdmi
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOFrpi

chmod 644 /lib/systemd/system/rpiplay.service
systemctl daemon-reload
systemctl enable rpiplay.service

rm -rf /tmp/rpiplay.zip
rm -rf /tmp/play

# ufw disable

# reboot
