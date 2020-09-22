#!/bin/bash
###############################################################################
# Enables unattended upgrades.  Typically used to restore this functionality 
# after at the end of a script run.  See disable_unattended_upgrades.sh.
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/236200
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Enabling unattended upgrades"
echo "--------------------------------------------------------------------------------"
sleep 5
systemctl start unattended-upgrades
systemctl status unattended-upgrades
systemctl enable unattended-upgrades
## dpkg-reconfigure -plow unattended-upgrades
cat /etc/apt/apt.conf.d/20auto-upgrades
dpkg --configure -a ; # make sure everything is in synch; unnessary..yes?
echo -e "FINISHED $BASH_SOURCE \n\n"
