#!/bin/bash

apt update && apt install syslog-ng wget curl nano htop ufw -y
systemctl status syslog-ng
syslog-ng -V

systemctl restart syslog-ng
systemctl status syslog-ng

# nano /etc/syslog-ng/syslog-ng.conf 
nano /etc/syslog-ng/conf.d/basic.conf

# version 1.0
# server configuration

#source
source s_linux {
        network(
                ip("192.168.50.182")
                transport("tcp")
                port(5140)
                );
};

#destination
destination d_linux_local {
        file("/data/message_${HOST}");
};

#log
log {
        source(s_linux);
        destination(d_linux_local);
};
