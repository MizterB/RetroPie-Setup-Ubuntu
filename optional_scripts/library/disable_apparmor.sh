#!/bin/bash
###############################################################################
# Disables the apparmor service
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling the apparmor service"
echo "--------------------------------------------------------------------------------"
systemctl disable apparmor
echo -e "FINISHED $BASH_SOURCE \n\n"
