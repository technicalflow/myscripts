#!/usr/bin/env bash

set -e

# Install syslog-ng
apt update && apt upgrade -y 
apt install wget curl nano htop ufw install syslog-ng -y 
mkdir -p /data/mikrotik && cd /data/
chown -R root /data/mikrotik/
mkdir -p mikrotik_logs

ufw allow ssh && ufw allow syslog
ufw enable && ufw status
systemctl restart syslog-ng && systemctl status syslog-ng && syslog-ng -V

#Enable Mikrotik configuration
cat << EOFmikrotiklog > /etc/syslog-ng/conf.d/mikrotik.conf

# version 1.0
# server configuration

#source
source s_mikrotik { udp (); };
#filter
filter f_mikrotik { host( "192.168.1.1" ); };
#destination
destination d_mikrotik_local {
        file("/data/mikrotik_logs/mikrotik_${YEAR}_${MONTH}_${DAY}.log");
};

#log
log {
        source(s_mikrotik);
        filter( f_mikrotik );
        destination(d_mikrotik_local);
};
EOFmikrotiklog

cat << EOFmikrotikfwlog > /etc/syslog-ng/conf.d/mikrotik_fw.conf
# version 1.0
# server configuration

#source is turned off because it is duplicated with mikrotik.conf
#source s_fw_mikrotik { udp (); };
#filter
filter f_fw_mikrotik { host( "192.168.2.1" ); };
#destination
destination d_fw_mikrotik_local {
        file("/data/mikrotik_logs/FW_mikrotik_${YEAR}_${MONTH}_${DAY}.log");
};

#log
log {
        source(s_mikrotik);
        filter( f_fw_mikrotik );
        destination(d_fw_mikrotik_local);
};
EOFmikrotikfwlog 
systemctl restart syslog-ng
