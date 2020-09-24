#!/bin/bash
###############################################################################
# Disables the unattended upgrade process, which can cause the master install
# script to fail when an unattended upgrade is already in progress. 
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/236200
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling unattended upgrades"
echo "--------------------------------------------------------------------------------"
systemctl stop unattended-upgrades
systemctl status unattended-upgrades
systemctl disable unattended-upgrades
# dpkg-reconfigure -plow unattended-upgrades 
# dpkg --configure -a 
# cat /etc/apt/apt.conf.d/20auto-upgrades
echo -e "FINISHED $BASH_SOURCE \n\n"
