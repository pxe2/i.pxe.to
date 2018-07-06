#!/bin/bash


ACTIVE_INTERFACE=`/sbin/ip route get 1 | /bin/tr -s " " | /bin/cut -d " " -f5`
NEWHOSTNAME=`/sbin/ifconfig $ACTIVE_INTERFACE | /bin/grep "HWaddr" | /bin/tr -s " " | /bin/cut -d " " -f5  | /bin/tr '[:upper:]' '[:lower:]' | /bin/sed -e "s/://g;"`


echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config


<<<<<<< HEAD
<<<<<<< HEAD
wget http://d5cc1d780d46.pouliot.net/rancheros/cloud-config.yml/rancheros-1.3.0-amd64.cloud-config.yml
=======
wget http://615f95e47bea.pouliot.net/rancheros/cloud-config.yml/rancheros-1.3.0-amd64.cloud-config.yml
>>>>>>> 03dcf6f73f84a91be510289cb2cf94cc05c8db60
=======
wget http://615f95e47bea.pouliot.net/rancheros/cloud-config.yml/rancheros-1.3.0-amd64.cloud-config.yml
>>>>>>> 03dcf6f73f84a91be510289cb2cf94cc05c8db60
sed -i "/hostname: rancheros/c\hostname: $NEWHOSTNAME" ./rancheros-1.3.0-amd64.cloud-config.yml
sudo ros config validate -i ./rancheros-1.3.0-amd64.cloud-config.yml
sudo ros config merge -i ./rancheros-1.3.0-amd64.cloud-config.yml

