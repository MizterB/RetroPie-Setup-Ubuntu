#!/bin/bash
#--------------------------------------------------------------------------------
# This script provides a simple, one-step approach for installing the 
# RetroPie-Setup-Ubuntu package and its requrired dependencies.
#--------------------------------------------------------------------------------
SCRIPT_DIR="$(pwd)"
REPO_NAME="RetroPie-Setup-Ubuntu"
REPO_URL="https://github.com/MizterB/$REPO_NAME"
REPO_BRANCH="LTS-20.04"

# Make sure the user is running the script via sudo
if [ -z "$SUDO_USER" ]; then
    echo "Installing RetroPie-Setup-Ubuntu requires sudo privileges. Please run with: sudo $0"
    exit 1
fi
# Don't allow the user to run this script from the root account. RetroPie doesn't like this.
if [[ "$SUDO_USER" == root ]]; then
    echo "RetroPie-Setup-Ubuntu should not be installed by the root user.  Please run as normal user using sudo."
    exit 1
fi

# Install Git
apt-get update && apt-get install -y git

# Clone the repository
git clone --depth 1 $REPO_URL.git
chown -R $SUDO_USER:$SUDO_USER $REPO_NAME
git switch $REPO_BRANCH

# Mark the setup script as executable
chmod +x $SCRIPT_DIR/$REPO_NAME/retropie_setup_ubuntu.sh

echo "-------------------------------------------------------------------------------"
echo " RetroPie-Setup-Ubuntu is now available at \"$SCRIPT_DIR/$REPO_NAME\"."
echo " If you want to include any optional packages before running the installer,"
echo " please configure them now."
echo " Instructions are available at $REPO_URL/blob/$REPO_BRANCH/README.md"
echo " "
echo " When ready to install, run:"
echo " sudo $SCRIPT_DIR/$REPO_NAME/retropie_setup_ubuntu.sh"
echo "-------------------------------------------------------------------------------"