#!/bin/bash

ACTIVE_INTERFACE=`/usr/bin/ip route get 1 | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f5`
NEWHOSTNAME=`/usr/bin/ifconfig $ACTIVE_INTERFACE | /usr/bin/grep "ether" | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f3 | /usr/bin/sed -e "s/://g;"`


DISCOVERY=`curl -w "\n" 'https://discovery.etcd.io/new?size=8'`

echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME
echo $DISCOVERY

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config

curl -O http://a737b1065522.pouliot.net/coreos/cloud-config.yml/coreos-beta-amd64.cloud-config.yml
sed -i "/hostname: coreos/c\hostname: $NEWHOSTNAME" ./coreos-beta-amd64.cloud-config.yml


#sed -i "/ discovery: \"https://discovery.etcd.io/<token>\"/c\ $DISCOVERY" ./coreos-beta-amd64.cloud-config.yml


# Run install 


if [ -e "/dev/vda" ]
then
  for v_partition in $(sudo parted -s /dev/vda print|awk '/^ / {print $1}')
  do
    sudo parted -s /dev/vda rm ${v_partition}
  done
 # Zero MBR
  sudo dd if=/dev/zero of=/dev/vda bs=512 count=1
  sudo coreos-install -d /dev/vda -C beta -c coreos-beta-amd64.cloud-config.yml
fi


if [ -e "/dev/sda" ]
then
  for partition in $(sudo parted -s /dev/sda print|awk '/^ / {print $1}')
  do
    sudo parted -s /dev/sda rm ${partition}
  done
  # Zero MBR
  sudo dd if=/dev/zero of=/dev/sda bs=512 count=1
  sudo coreos-install -d /dev/sda -C beta -c coreos-beta-amd64.cloud-config.yml
fi

# Reboot 
sudo reboot


