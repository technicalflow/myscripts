#!/bin/bash

# Install syslog-ng
apt update && apt install -y nano wget curl htop syslog-ng
systemctl status syslog-ng

# Check connectivity to syslog-ng server
nc -zv 192.168.50.182 5140

# Edit configuration
nano /etc/syslog-ng/conf.d/basic.conf

# version 1.0
# client configuration

#source
source s_auth {
        file("/var/log/*");
};

#destination
destination d_linux {
        network (
                "192.168.50.182"
                transport("tcp")
                port(5140)
                );
};

#log
log {
        source(s_auth);
        destination(d_linux);
};


systemctl restart syslog-ng