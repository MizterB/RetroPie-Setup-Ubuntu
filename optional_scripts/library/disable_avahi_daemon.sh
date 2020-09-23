#!/bin/bash
###############################################################################
# Disables the avahi-daemon service
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling the avahi-daemon service"
echo "--------------------------------------------------------------------------------"
systemctl disable avahi-daemon.service
echo -e "FINISHED $BASH_SOURCE \n\n"
