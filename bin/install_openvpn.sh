
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

## package check
log_info_ "package check"
#PACKAGES=(openvpn libssl-dev openssl easy-rsa)
#for package in ${PACKAGES[@]}; do
#	dpkg -l $package | grep -E "^i.+[ \t]+$package" > /dev/null
#	if [ $? -ne 0 ];then
#		echo "apt-get install -y $package."
#		sudo apt-get install -y $package
#	fi
#done

EASYRSADIR=/etc/openvpn/easy-rsa
log_info_ "sudo make-cadir $EASYRSADIR"
#sudo make-cadir $EASYRSADIR
log_info_ "sudo mv $EASYRSADIR/vars $EASYRSADIR/vars.org"
#sudo mv $EASYRSADIR/vars $EASYRSADIR/vars.org
log_info_ "sudo cp $CONFDIR/vars $EASYRSADIR/"
#sudo cp $CONFDIR/vars $EASYRSADIR/
log_info_ "sudo source $EASYRSADIR/vars"
log_info_ "sudo sh $EASYRSADIR/clean-all"
log_info_ "sudo sh $EASYRSADIR/build-ca"
log_info_ "sudo sh $EASYRSADIR/pkitool --server server"
log_info_ "sudo sh $EASYRSADIR/build-key-server VPN_test"
log_info_ "sudo sh $EASYRSADIR/build-dh"
#sudo bash -c "cd $EASYRSADIR;source vars && ./clean-all && ./build-ca && ./pkitool --initca && ./pkitool --server server && ./build-key-server VPN_test && ./build-dh && ./build-key VPN_test_client && openvpn --genkey --secret /etc/openvpn/easy-rsa/keys/ta.key"

log_info_ "create server.conf"
log_info_ "sudo cp $CONFDIR/openvpn/server.conf /etc/openvpn/"
#sudo cp $CONFDIR/openvpn/server.conf /etc/openvpn/


log_info_ "copy client keys to $CLIENTDIR"
sudo cp /etc/openvpn/easy-rsa/keys/ca.crt $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/ta.key $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/VPN_test_client.crt $CLIENTDIR
sudo cp /etc/openvpn/easy-rsa/keys/VPN_test_client.key $CLIENTDIR

cd $pwd