
#!/bin/bash
export LANG=C
pwd=`pwd`
cd `dirname $0`

sudo service openvpn start
#sudo chkconfig openvpn on
sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
sudo iptables -A INPUT -i tun+ -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -i tun+ -j ACCEPT
sudo iptables -A FORWARD -m state --state NEW -o eth0 -j ACCEPT
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m state --state NEW -o eth0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o eth0 -j MASQUERADE
#sudo service iptables save
sudo service ufw restart



cd $pwd