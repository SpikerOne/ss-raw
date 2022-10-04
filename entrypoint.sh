#!/bin/bash

mkdir /v2raybin
cd /v2raybin
V2RAY_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-darwin-amd64-v1.3.2.tar.gz"
echo ${V2RAY_URL}
wget --no-check-certificate ${V2RAY_URL}
tar -zxvf v2ray-plugin-linux-amd64-$V_VER.tar.gz
rm -rf v2ray-plugin-linux-amd64-$V_VER.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -rf /v2raybin

cd /wwwroot
tar xvf wwwroot.tar.gz
rm -rf wwwroot.tar.gz

if [ ! -d /etc/shadowsocks-libev ]; then  
  mkdir /etc/shadowsocks-libev
fi

sed -e "/^#/d"\
    -e "s/\${PASSWORD}/password/g"\
    -e "s|\${V2_Path}|/v2ray|g"\
    /conf/shadowsocks-libev_config.json >  /etc/shadowsocks-libev/config.json
echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

sed -e "/^#/d"\
    -e "s/\${PORT}/443/g"\
    -e "s|\${V2_Path}|/v2ray|g"\
    -e "$s"\
    /conf/nginx_ss.conf > /etc/nginx/conf.d/ss.conf
echo /etc/nginx/conf.d/ss.conf
cat /etc/nginx/conf.d/ss.conf

ss-server -c /etc/shadowsocks-libev/config.json &
rm -rf /etc/nginx/sites-enabled/default
nginx -g 'daemon off;'
