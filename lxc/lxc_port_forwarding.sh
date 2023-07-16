lxc config device show centos7
port80:
  connect: tcp:127.0.0.1:80
  listen: tcp:0.0.0.0:8080
  type: proxy
port443:
  connect: tcp:127.0.0.1:443
  listen: tcp:0.0.0.0:8443
  type: proxy