#!/bin/bash
#=GENERATE CLIENT CERTIFICATES AND CONFIG FILES

CLIENTNAME=$1

usage(){
        echo "Usage: $0 CLIENTNAME"
        exit 1
}

# invoke  usage
# call usage() function if CLIENTNAME not supplied
[[ $# -eq 0 ]] && usage

#CLIENTNAME - name for client  (e.g., "home-laptop", "work-laptop", "nexus5", etc.).
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn easyrsa build-client-full $CLIENTNAME nopass
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
