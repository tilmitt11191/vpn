
#!/bin/bash
export LANG=C
pwd=`pwd`
cd `dirname $0`

ROOTDIR="`pwd`/.."
CONFDIR="$ROOTDIR/etc"
CLIENTDIR="$ROOTDIR/etc/client/openvpn"

source ../lib/util/logger.sh
LOG_FILE="../var/log/log_install-openvpn"
function log_info_() { log_info "$1" "$LOG_FILE";}

log_info_ "install_openvpn.sh start"

EASYRSADIR=/etc/openvpn/easy-rsa
log_info_ "sudo source $EASYRSADIR/vars"
log_info_ "sudo sh $EASYRSADIR/clean-all"
log_info_ "sudo sh $EASYRSADIR/build-ca"
log_info_ "sudo sh $EASYRSADIR/./pkitool --initca"
log_info_ "sudo sh $EASYRSADIR/pkitool --server server"
log_info_ "sudo sh $EASYRSADIR/build-key-server VPN_test"
log_info_ "sudo sh $EASYRSADIR/build-dh"
log_info_ "sudo sh $EASYRSADIR/./build-key VPN_test_client"
log_info_ "sudo sh $EASYRSADIR/openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key"
#sudo bash -c "cd $EASYRSADIR;source vars && ./clean-all && ./build-ca && ./pkitool --initca && ./pkitool --server server && ./build-key-server VPN_test && ./build-dh && ./build-key VPN_test_client && openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key"
#sudo bash -c "cd $EASYRSADIR;source vars && ./clean-all && ./build-ca && ./build-key-server VPN_test && ./build-dh && ./build-key VPN_test_client"
sudo bash -c "cd $EASYRSADIR;source vars && ./clean-all && ./build-ca && ./build-key-server VPN_test && ./build-dh && ./build-key VPN_test_client && openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key"

log_info_ "create server.conf"
log_info_ "sudo cp $CONFDIR/openvpn/server.conf /etc/openvpn/"
sudo cp $CONFDIR/openvpn/server.conf /etc/openvpn/


log_info_ "copy client keys to $CLIENTDIR"
sudo cp /etc/openvpn/easy-rsa/keys/ca.crt $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/ta.key $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/VPN_test_client.crt $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/VPN_test_client.key $CLIENTDIR

log_info_ "install_openvpn.sh finished"
cd $pwd

#sudo bash -c "cd $EASYRSADIR;source vars && ./clean-all && ./build-ca && ./pkitool --initca && ./pkitool --server server && ./build-key-server VPN_test && ./build-dh && ./build-key VPN_test_client && openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key"