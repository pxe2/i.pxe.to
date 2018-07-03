#!/bin/bash


ACTIVE_INTERFACE=`/sbin/ip route get 1 | /bin/tr -s " " | /bin/cut -d " " -f5`
NEWHOSTNAME=`/sbin/ifconfig $ACTIVE_INTERFACE | /bin/grep "HWaddr" | /bin/tr -s " " | /bin/cut -d " " -f5  | /bin/tr '[:upper:]' '[:lower:]' | /bin/sed -e "s/://g;"`

DISCOVERY=`curl -w "\n" 'https://discovery.etcd.io/new?size=8'`

echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME
echo $DISCOVERY

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config


wget http://a737b1065522.pouliot.net/rancheros/cloud-config.yml/rancheros-1.2.0-amd64.cloud-config.yml
sed -i "/hostname: rancheros/c\hostname: $NEWHOSTNAME" ./rancheros-1.2.0-amd64.cloud-config.yml

#sed -i "/ discovery: \"https://discovery.etcd.io/<token>\"/c\ $DISCOVERY" ./rancheros-1.2.0-amd64.cloud-config.yml


# Run install 



INSTALL_DISK="/dev/vda"
if ! fdisk -l $INSTALL_DISK; then
	INSTALL_DISK="/dev/sda"
fi
sudo ros install -c ./rancheros-1.2.0-amd64.cloud-config.yml -d $INSTALL_DISK -f

