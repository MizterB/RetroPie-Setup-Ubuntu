#!/bin/bash
###############################################################################
# Turn the X mouse pointer into 1x1 pixel black dot, hiding it completely.
#
# This further enhances the default behavior, which uses the 'unclutter' 
# program show the mouse pointer when moved, and hide after a second of 
# inactivity
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234104
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Turning the X mouse pointer into 1x1 pixel black dot"
echo "--------------------------------------------------------------------------------"
git clone --depth=1 https://github.com/etheling/dot1x1-gnome-cursor-theme /tmp/dot1x1-gnome-cursor-theme
tar zxf /tmp/dot1x1-gnome-cursor-theme/dot1x1-cursor-theme.tar.gz -C /usr/share/icons
cp /usr/share/icons/default/index.theme /usr/share/icons/default/index.theme.orig
cp dot1x1-gnome-cursor-theme/index.theme /usr/share/icons/default/index.theme
rm -rf /tmp/dot1x1-gnome-cursor-theme
echo -e "FINISHED $BASH_SOURCE \n\n"