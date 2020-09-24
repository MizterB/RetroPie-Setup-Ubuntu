#!/bin/bash
###############################################################################
# Disables Samba's smbd and nmbd services
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling the Samba services (smbd, nmbd)"
echo "--------------------------------------------------------------------------------"
systemctl disable smbd.service nmbd.service
echo -e "FINISHED $BASH_SOURCE \n\n"
