#!/bin/bash

ACTIVE_INTERFACE=`/usr/bin/ip route get 1 | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f5`
NEWHOSTNAME=`/usr/bin/ifconfig $ACTIVE_INTERFACE | /usr/bin/grep "ether" | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f3 | /usr/bin/sed -e "s/://g;"`



echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config

<<<<<<< HEAD
<<<<<<< HEAD
curl -O http://d5cc1d780d46.pouliot.net/coreos/cloud-config.yml/coreos-stable-amd64.cloud-config.yml
=======
curl -O http://615f95e47bea.pouliot.net/coreos/cloud-config.yml/coreos-stable-amd64.cloud-config.yml
>>>>>>> 03dcf6f73f84a91be510289cb2cf94cc05c8db60
=======
curl -O http://615f95e47bea.pouliot.net/coreos/cloud-config.yml/coreos-stable-amd64.cloud-config.yml
>>>>>>> 03dcf6f73f84a91be510289cb2cf94cc05c8db60
sed -i "/hostname: coreos/c\hostname: $NEWHOSTNAME" ./coreos-stable-amd64.cloud-config.yml
# apply cloud config
sudo coreos-cloudinit -validate --from-file ./coreos-stable-amd64.cloud-config.yml
sudo coreos-cloudinit --from-file ./coreos-stable-amd64.cloud-config.yml


