#!/bin/bash
###############################################################################
# Remove snap daemon
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Removing snap daemon"
echo "--------------------------------------------------------------------------------"
snap list
snap remove lxd
snap remove core18
snap remove snapd
## TODO: maybe rm -rf /snapd  
echo -e "FINISHED $BASH_SOURCE \n\n"
