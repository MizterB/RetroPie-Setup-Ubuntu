#!/bin/bash
###############################################################################
# Disable Spectre, Meltdown, etc. mitigations in kernel
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling Spectre, Meltdown, etc. kernel mitigations"
echo "--------------------------------------------------------------------------------"
cp /etc/default/grub /etc/default/grub.backup-$(date +"%Y%m%d_%H%M%S")
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\"/&mitigations=off /' /etc/default/grub
update-grub
echo -e "FINISHED $BASH_SOURCE \n\n"
