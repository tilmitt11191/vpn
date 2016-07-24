
#!/bin/bash
export LANG=C
pwd=`pwd`
cd `dirname $0`

SERVER_CONF=../etc/openvpn/server.conf
UFW_CONF=../etc/ufw/before.rules
CLIENT_CONF=../etc/client/openvpn/client.ovpn
OPENVPN_DIR=/etc/openvpn

SERVER_IP=192.168.24.3
SERVER_PORT=26262
SERVER_RANGE=192.168.230.0
SERVER_NETMASK=255.255.255.0
NIC=enp0s3
DNS1=8.8.8.8
DNS2=8.8.4.4

CLIENT_CERT_NAME=VPN_test_client.crt
CLIENT_KEY_NAME=VPN_test_client.key

source ../lib/util/logger.sh
LOG_FILE="../var/log/log_install-openvpn"
function log_info_() { log_info "$1" "$LOG_FILE";}

log_info_ "configure_openvpn.sh start"



log_info_ "create $SERVER_CONF"
sed -i -e s/^server.*/"server $SERVER_RANGE $SERVER_NETMASK"/g $SERVER_CONF
sed -i -e /".*dhcp-option DNS.*"/d $SERVER_CONF
echo "push dhcp-option DNS $DNS1" >> $SERVER_CONF
echo "push dhcp-option DNS $DNS2" >> $SERVER_CONF

log_info_ "deploy $SERVER_CONF"
if [ -e $OPENVPN_DIR/server.conf ];then
	sudo mv $OPENVPN_DIR/server.conf $OPENVPN_DIR/server.conf.backup
fi
sudo cp $SERVER_CONF $OPENVPN_DIR

log_info_ "deploy UFW_CONF"
if [ -e /etc/ufw/before.rules ];then
	sudo mv /etc/ufw/before.rules /etc/ufw/before.rules.backup
fi
sed -i -e s/^"-A POSTROUTING -s ".*/"-A POSTROUTING -s $SERVER_RANGE\/$SERVER_NETMASK -o $NIC -j MASQUERADE"/g $UFW_CONF
sudo cp $UFW_CONF /etc/ufw/before.rules


log_info_ "create $CLIENT_CONF"
sed -i -e s/^remote.*/"remote $SERVER_IP $SERVER_PORT"/g $CLIENT_CONF
sed -i -e s/^cert.*/"cert $CLIENT_CERT_NAME"/g $CLIENT_CONF
sed -i -e s/^key.*/"key $CLIENT_KEY_NAME"/g $CLIENT_CONF


log_info_ "routing configuration"
#if [ -e /etc/iptables.rule ];then
#	sudo mv /etc/iptables.rule /etc/iptables.rule.backup
#fi
#sudo iptables -t nat -A POSTROUTING -s $SERVER_RANGE/$SERVER_NETMASK -o $NIC -j MASQUERADE
#sudo /sbin/iptables-save -c | sudo tee -a /etc/iptables.rule

sed -i -e s@^/sbin/route.*@"/sbin/route add -net $SERVER_RANGE netmask $SERVER_NETMASK dev $NIC"@g ../etc/network/if-up.d/routes
sudo cp ../etc/network/if-pre-up.d/iptables_restore /etc/network/if-pre-up.d/
sudo chmod +x /etc/network/if-pre-up.d/iptables_restore
sudo cp ../etc/network/if-up.d/routes /etc/network/if-up.d/
sudo chmod +x /etc/network/if-up.d/routes



log_info_ "register openvpn on startup"
sudo sysv-rc-conf openvpn on


log_info_ "configure_openvpn.sh finished"
cd $pwd
