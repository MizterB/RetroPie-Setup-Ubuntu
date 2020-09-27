#!/bin/bash
###############################################################################
# Disable IPv6 which is known to have a potential negative impact on some
# applications and services.
#
#
# Contributor: johnodon
# Reference: https://tek.io/3j7AdmN
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Disabling IPV6…“
echo "--------------------------------------------------------------------------------"

# Disable IPv6 via GRUB
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 /' /etc/default/grub
sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
update-grub

echo -e "FINISHED $BASH_SOURCE \n\n"
