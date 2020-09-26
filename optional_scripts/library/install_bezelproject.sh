#!/bin/bash
###############################################################################
# Install the Bezel Project into the RetroPie menu.
# Configuration should be completed through the menu option
# See https://github.com/thebezelproject/BezelProject
#
# NOTE: Should be installed as a post_install script
#
# Contributor: MizterB
# Reference: https://github.com/MizterB/RetroPie-Setup-Ubuntu/issues/2
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Installing the Bezel Project to the RetroPie menu"
echo "--------------------------------------------------------------------------------"
mkdir -p "$USER_HOME/RetroPie/retropiemenu"
wget -O "$USER_HOME/RetroPie/retropiemenu/bezelproject.sh" "https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh"
chmod +x "$USER_HOME/RetroPie/retropiemenu/bezelproject.sh"
echo -e "FINISHED $BASH_SOURCE \n\n"
