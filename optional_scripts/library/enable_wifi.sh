#!/bin/bash
###############################################################################
# Install WiFi support via the wpasupplicant package.
# Configuration should be completed via retropie-setup
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Enabling WiFi support.  Configuration should be completed via retropie-setup."
echo "--------------------------------------------------------------------------------"
apt-get install -y $APT_RECOMMENDS wpasupplicant
echo -e "FINISHED $BASH_SOURCE \n\n"
