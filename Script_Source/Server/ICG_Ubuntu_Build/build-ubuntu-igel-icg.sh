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
# of Ubuntu Server 18.04 / 20.04 to be hardened for IGEL ICG installation.
#
# Items installed / configured include:
#
#  - Prepped for a IGEL ICG install
#  - Time service (chrony)
#  - OpenSSH
#  - UFW Firewall
#  - Fail2ban Automatic Banning
#  - Rootkit Hunter (Rkhunter)
#  - Port Knocking (Knockd) -- Note: install knock client on PC
#  - ClamAV -- open source anti-virus engine
#

#
# Vars used in script -- MUST EDIT to Match
#
# Determine the time zone ICG server lives in -- timedatectl list-timezones
#TIMEZONE="Europe/Vilnius"
#TIMEZONE="Europe/Berlin"
#TIMEZONE="Europe/Paris"
#TIMEZONE="Europe/London"
#TIMEZONE="America/New_York"
TIMEZONE="America/Chicago"
#TIMEZONE="America/Denver"
#TIMEZONE="America/Los_Angeles"

IGEL_MASTER=192.168.1.197
IGEL_MASTER_USER=igelums
IGEL_ICG_INSTALL=192.168.1.14
IGEL_ICG_USER=icginstall
TMPDIR=/tmp

#
# Ubuntu 18.04 / 20.04 Server with:
#
# Lastest update / upgrade
echo "******* Starting -- apt-get update / upgrade / dist-upgrade / autoremove"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
echo "******* Ending -- apt-get update / upgrade / dist-upgrade / autoremove"

#
# Time Service
#
echo "******* Starting -- apt install chrony"
sudo timedatectl set-timezone $TIMEZONE
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
#   - Check listing port -- sudo netstat -tulpn
# Ref: https://tinyurl.com/ssh-setup
#
echo "******* Starting -- apt install openssh-server"
sudo apt install openssh-server -y

SSHCONFIG=/etc/ssh/sshd_config

sudo sed -i "/#Port 22/ a Port 60022" $SSHCONFIG
sudo sed -i "/#PermitRootLogin/ a PermitRootLogin no" $SSHCONFIG
sudo sed -i "/#PermitEmptyPasswords no/ a PermitEmptyPasswords no" $SSHCONFIG
sudo sed -i "\$ a AllowUsers $IGEL_MASTER_USER@$IGEL_MASTER" $SSHCONFIG
sudo sed -i "\$ a AllowUsers $IGEL_ICG_USER@$IGEL_ICG_INSTALL" $SSHCONFIG

sudo systemctl stop sshd.service
sudo systemctl start sshd.service
sudo systemctl enable sshd.service
echo "******* Ending -- apt install openssh-server"

#
# UFW Firewall Setup. SSH will be shown later
#
echo "******* Starting -- UFW Firewall Setup"
sudo apt install ufw -y
sudo ufw status
sudo ufw default allow outgoing
sudo ufw allow 8443/tcp
sudo ufw enable
sudo ufw status
echo "******* Ending -- UFW Firewall Setup"

#
# Fail2ban Automatic Banning Setup
#
echo "******* Starting -- Faile2ban Automatic Banning"
sudo apt-get install fail2ban -y

JAIL_LOCAL=/etc/fail2ban/jail.local

cat << EOF >> $TMPDIR/jail.local
[sshd]
   enabled = true
   port = 60022
   filter = sshd
   logpath = /var/log/auth.log
   maxretry = 3
EOF

sudo cp $TMPDIR/jail.local $JAIL_LOCAL
sudo chmod 644 $JAIL_LOCAL

sudo systemctl status fail2ban
sudo systemctl restart fail2ban
sudo fail2ban-client status sshd
#sudo fail2ban-client set sshd unbanip $IGEL_ICG_INSTALL
echo "******* Ending -- Faile2ban Automatic Banning"

#
# Rootkit Hunter (Rkhunter) Setup
#
echo "******* Starting -- Rootkit Hunter (Rkhunter) Setup"
sudo apt-get install rkhunter -y
sudo rkhunter -c
#sudo useradd empty2
#sudo rkhunter -c --enable local_host
echo "******* Ending -- Rootkit Hunter (Rkhunter) Setup"

#
# Port Knocking (Knockd)
#
echo "******* Starting -- Port Knocking (Knockd)"
sudo apt-get install knockd -y

KNOCKD_CONF=/etc/knockd.conf

cat << EOF >> $TMPDIR/knockd.conf
[options]
	UseSyslog

[openSSH]
	sequence    = 7000,8000,9000
	seq_timeout = 10
	command     = /usr/sbin/ufw allow from %IP% to any port 60022
	tcpflags    = syn

[closeSSH]
	sequence    = 9000,8000,7000
	seq_timeout = 10
	command     = /usr/sbin/ufw delete allow from %IP% to any port 60022
	tcpflags    = syn
EOF

sudo cp $TMPDIR/knockd.conf $KNOCKD_CONF
sudo chmod 644 $KNOCKD_CONF

KNOCKD=/etc/default/knockd

NETWORKID=`ifconfig | grep "^en" | awk --field-separator : '{print $1}'`

sudo sed -i "\$ a START_KNOCKD=1" $KNOCKD
sudo sed -i "\$ a KNOCKD_OPTS=\"-i $NETWORKID\"" $KNOCKD

sudo systemctl restart knockd
echo "******* Ending -- Port Knocking (Knockd)"

#
# ClamAV - anti-virus engine
# https://www.clamav.net/
#
echo "******* Starting -- ClamAV anti-virus"
sudo apt-get install clamav clamav-daemon -y
echo "******* Ending -- ClamAV anti-virus"

#
# Ready to reboot
#
