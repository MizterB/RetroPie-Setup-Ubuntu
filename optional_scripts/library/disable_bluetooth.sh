#!/bin/bash
###############################################################################
# Disables the bluetooth service
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling the bluetooth service"
echo "--------------------------------------------------------------------------------"
systemctl disable bluetooth.service
echo -e "FINISHED $BASH_SOURCE \n\n"
