#!/bin/bash
OVPN_DATA="ovpn-data"
MYIP=$1

usage(){
        echo "Usage: $0 MYIP"
        exit 1
}

# invoke  usage
# call usage() function if MYIP not supplied
[[ $# -eq 0 ]] && usage

#=Install DOCKER
wget -q -O - https://get.docker.io/gpg | sudo apt-key add -
echo deb http://get.docker.io/ubuntu docker main | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update && sudo apt-get install -y lxc-docker

#=USERMOD
#USER - your username
sudo usermod -aG docker $USER

#=CHECK DOCKER
docker run --rm debian:jessie

#=SET UP THE EASYRSA PKI CERTIFICATE STORE
docker run --name $OVPN_DATA -v /etc/openvpn busybox
docker run --volumes-from $OVPN_DATA --rm kylemanna/openvpn ovpn_genconfig -u udp://$MYIP:1194
docker run --volumes-from $OVPN_DATA --rm -it kylemanna/openvpn ovpn_initpki nopass

#=LAUNCH THE OPENVPN SERVER
sudo bash -c 'cat << EOF > /etc/init/docker-openvpn.conf
description "Docker container for OpenVPN server"
start on filesystem and started docker
stop on runlevel [!2345]
respawn
script
  exec docker run --volumes-from ovpn-data --rm -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
end script
EOF'

sudo start docker-openvpn;docker ps -a
