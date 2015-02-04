#!/bin/bash
#=SET UP OPENVPN CLIENTS

CLIENTNAME=$1

usage(){
        echo "Usage: $0 CLIENTNAME"
        exit 1
}

# invoke  usage
# call usage() function if CLIENTNAME not supplied
[[ $# -eq 0 ]] && usage

sudo apt-get install openvpn
sudo install -o root -m 400 $CLIENTNAME.ovpn /etc/openvpn/$CLIENTNAME.conf
echo AUTOSTART=all | sudo tee -a /etc/default/openvpn
sudo /etc/init.d/openvpn restart

#=VERIFY OPERATION
wget -qO - icanhazip.com
