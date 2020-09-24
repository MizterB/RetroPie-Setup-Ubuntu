#!/bin/bash
###############################################################################
# Forces APT to use IPV4, which can prevent package installation errors when
# IPV6 name resolution fails for some users.
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/236200
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Forcing apt to use IPV4"
echo "--------------------------------------------------------------------------------"
## https://unix.stackexchange.com/questions/9940/convince-apt-get-not-to-use-ipv6-method
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
echo -e "FINISHED $BASH_SOURCE \n\n"
