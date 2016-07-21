
#!/bin/bash
export LANG=C
pwd=`pwd`
cd `dirname $0`


SERVER_RANGE=192.168.240.0
SERVER_NETMASK=255.255.255.0

sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
sudo iptables -A INPUT -i tun+ -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -i tun+ -j ACCEPT
sudo iptables -A FORWARD -m state --state NEW -o eth0 -j ACCEPT
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m state --state NEW -o eth0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s $SERVER_RANGE/$SERVER_NETMASK -o eth0 -j MASQUERADE
#sudo service iptables save
sudo service ufw restart

sudo service openvpn restart
#sudo chkconfig openvpn on


cd $pwd