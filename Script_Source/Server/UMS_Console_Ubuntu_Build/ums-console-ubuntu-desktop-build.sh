#!/bin/bash
# uncomment set and trap to trace execution
#set -x
#trap read debug

#
# Run this script after initial install
#
# If you try to run on an existing system, some of the commands,
# such as sed and cp, may not work as expected.
#
# This script will update and configure a FRESHLY installed version
# of Ubuntu Desktop 18.04 / 20.04 to be used to install / run UMS Console(s).
#
# Items installed / configured include:
#
#  - Prepped for a VirtualBox install
#  - Time service (chrony)
#  - OpenSSH
#

#
# Ubuntu 18.04 / 20.04 Desktop with:
#
# Lastest update / upgrade
echo "******* Starting -- apt-get update; apt-get upgrade"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "******* Ending -- apt-get update; apt-get upgrade"

#
# Basic utils
#
# Required if you are planning to install VirtualBox
# Ref: https://www.virtualbox.org
#
# After install, mount the VirutalBox guest additions and install
#
# sudo mkdir /media/cdrom
# sudo mount /dev/cdrom /media/cdrom
# cd /media/cdrom
# sudo sh ./VBoxLinuxAdditions.run
# sudo vi /etc/group # add user to vbox group
#
echo "******* Starting -- apt-get install build-essential gcc make perl dkms"
sudo apt-get install build-essential gcc make perl dkms -y
echo "******* Ending -- apt-get install build-essential gcc make perl dkms"

#
# Time Service
#
echo "******* Starting -- apt install chrony"
sudo apt install chrony -y
echo "******* Ending -- apt install chrony"

#
# OpenSSH
#
# Actions after install may include:
#
#   - Generate key pairs in .ssh directory -- ssh-keygen
#   - Copy public key to remote server -- ssh-copy-id username@remote_host
#   - Test connection -- ssh -l username hostname
#
# Ref: https://tinyurl.com/ssh-setup
#
echo "******* Starting -- apt install openssh-server"
sudo apt install openssh-server -y

#
# Allow X11 forwarding
#
SSHCONFIG=/etc/ssh/ssh_config

sudo sed -i "s/#   ForwardX11 no/    ForwardX11 yes/" $SSHCONFIG
sudo sed -i "s/#   ForwardX11Trusted yes/    ForwardX11Trusted yes/" $SSHCONFIG

sudo systemctl enable sshd.service
sudo systemctl start sshd.service
echo "******* Ending -- apt install openssh-server"


#
# Ready to reboot
#
#sudo reboot now
