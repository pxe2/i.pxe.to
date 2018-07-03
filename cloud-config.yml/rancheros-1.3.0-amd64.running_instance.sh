#!/bin/bash


ACTIVE_INTERFACE=`/sbin/ip route get 1 | /bin/tr -s " " | /bin/cut -d " " -f5`
NEWHOSTNAME=`/sbin/ifconfig $ACTIVE_INTERFACE | /bin/grep "HWaddr" | /bin/tr -s " " | /bin/cut -d " " -f5  | /bin/tr '[:upper:]' '[:lower:]' | /bin/sed -e "s/://g;"`


echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config


wget http://a737b1065522.pouliot.net/rancheros/cloud-config.yml/rancheros-1.3.0-amd64.cloud-config.yml
sed -i "/hostname: rancheros/c\hostname: $NEWHOSTNAME" ./rancheros-1.3.0-amd64.cloud-config.yml
sudo ros config validate -i ./rancheros-1.3.0-amd64.cloud-config.yml
sudo ros config merge -i ./rancheros-1.3.0-amd64.cloud-config.yml

