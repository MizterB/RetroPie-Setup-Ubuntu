#!/bin/bash
###############################################################################
# Disables the ModemManager service
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling the ModemManager service"
echo "--------------------------------------------------------------------------------"
systemctl disable ModemManager.service
echo -e "FINISHED $BASH_SOURCE \n\n"
