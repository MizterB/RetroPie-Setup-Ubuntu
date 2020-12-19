#!/bin/bash
###############################################################################
# Install WineHQ for running gog.com games, or other Windows software
# via RetroPie ports. Supports running RetroPie under KMS/DRM and X.
#
# Important files / directories:
#   /dev/shm/portruncommand.sh       - if exists, startx will launch this
#                                      command as xsession
#   /dev/shm                         - debug logs
#   /home/<USER>/winehq/*            - WineHQ 32bit, 64bit prefixes and
#                                      shared data
#   /home/<USER>/.xsession           - logic to launch X or application as X
#                                      session (created by this script)
#
# Sample shell script to launch gog.com game under /home/<U>/RetroPie/ports
# URL: https://paste.ubuntu.com/p/vRmWxgxsBw/
#
# Note: Does NOT enable ports under Emulation Station. Easiest way to achieve
#       this is to install something from the ports collection.
#       (e.g. sudo /home/pi/RetroPie-Setup/retropie_packages.sh uqm)
#
# Note: Must be run using sudo
# 
# Contributor: etheling
# Reference: https://retropie.org.uk/forum/topic/18810/retropie-installation-on-ubuntu-server-x64-18-04-1/192
#
###############################################################################

echo " "
echo "+-------------------------------------------------------------------------------"
echo "| Install Wine for running Windows applications - https://www.winehq.org/"
echo "+-------------------------------------------------------------------------------"

USER="$SUDO_USER"
USER_HOME="/home/$USER"
cd $USER_HOME

echo "-> Add packages needed for extracting windows installers, cabs,.."
apt-get install -y cabextract innoextract bchunk

## but use Ubuntu stock package instead of https://wiki.winehq.org/Ubuntu
sudo dpkg --add-architecture i386
sudo apt -y update
sudo apt-get install -y wine wine32 wine64

## install wine tricks - https://wiki.winehq.org/Winetricks
if [ -f /usr/local/bin/winetricks ]; then
    mv -v /usr/local/bin/winetricks /tmp/winetricks.previous
    rm -fv /usr/local/bin/winetricks
fi
wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod -v +x /usr/local/bin/winetricks

## Note: winbind is 'needed' by dotnet* installs
sudo apt-get install -y winbind

## Create and initialize separate WineHQ prefixes for win32 and win64
sudo -u $USER mkdir -p /home/$USER/winehq/shared

## https://askubuntu.com/questions/278992/how-to-keep-wine-from-creating-directories-in-my-home-directory
echo "-> Temporarily setting user $USER HOME to /home/$USER/winehq/shared for fake 'root' for wine"
OLDHOME=$HOME
export HOME="/home/$USER/winehq/shared"
WINEARCHS=( "win32" "win64" )    
for WARCH in ${WINEARCHS[*]}; do
    echo "-> Setting up $WARCH. WINEPREFIX=/home/$USER/winehq/$WARCH"
    
    sudo -u $USER WINEPREFIX=/home/$USER/winehq/$WARCH WINEARCH="$WARCH" winecfg
    
    ##sudo -u $USER winetricks -q corefonts
    sudo -u $USER WINEPREFIX=/home/$USER/winehq/$WARCH WINEARCH="$WARCH" winetricks -q xact
    sudo -u $USER WINEPREFIX=/home/$USER/winehq/$WARCH WINEARCH="$WARCH" winetricks -q d3dx9
    sudo -u $USER WINEPREFIX=/home/$USER/winehq/$WARCH WINEARCH="$WARCH" winetricks -q d3dx10
    sudo -u $USER WINEPREFIX=/home/$USER/winehq/$WARCH WINEARCH="$WARCH" winetricks -q d3dx11_43
    
    echo "-> Removing and re-creating user folders"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/Templates"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/My Videos"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/My Pictures"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/My Music"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/My Documents"
    rm -v "/home/$USER/winehq/$WARCH/drive_c/users/pi/Downloads"
    ## create symlinks to ~/winehq/shared instead of ~/
    
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/Templates"
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/Downloads"
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/My Videos"
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/My Documents"
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/My Music"
    ln -vs "/home/$USER/winehq/shared" "/home/$USER/winehq/$WARCH/drive_c/users/$USER/My Pictures"		
done

## set Windows version to 7 for Win32, and Win10 for win64
echo "-> Set Windows OS versions for 32bit and 64bit wine"
sudo -u $USER WINEPREFIX=/home/$USER/winehq/win32 WINEARCH="win32" winetricks -q win7
sudo -u $USER WINEPREFIX=/home/$USER/winehq/win64 WINEARCH="win64" winetricks -q win10
    

##sudo -u $USER winetricks -q dotnet40
#sudo -u $USER winetricks -q dotnet45 ; # would require setting machine to w2k3
## https://askubuntu.com/questions/783211/cant-install-dotnet45-with-winetricks-on-ubuntu-14-04

## Need to be installed under X if needed
#sudo -u $USER winetricks -q vcrun6
#sudo -u $USER winetricks -q vcrun2005
#sudo -u $USER winetricks -q vcrun2008
    
sudo -u $USER WINEPREFIX=/home/$USER/winehq/win32 WINEARCH="win32" winetricks list-installed
sudo -u $USER WINEPREFIX=/home/$USER/winehq/win64 WINEARCH="win64" winetricks list-installed

export HOME=$OLDHOME

cd $CURDIR

echo -n "Wine version: "
wine --version

### Wine installed; now install .xsession
XSESSIONFILE=$USER_HOME/.xsession
echo "Backup $XSESSIONFILE"
cp -v $XSESSIONFILE $XSESSIONFILE.orig

cat << EOF > $XSESSIONFILE
## 
## Start /dev/shm/portruncommand.sh as X session if it exists. Otherwise
## start openbox normally. Debug logs are in /dev/shm/...

## give X time to start (shouldn't be needed)
#sleep 1

## document xrandr output \$XRANDR_LOG
XRANDR_LOG=/dev/shm/xrand_modes.log
xrandr --version >> \$XRANDR_LOG 2>&1
xrandr >> \$XRANDR_LOG 2>&1

# Update the next line to customize the display resolution
# If will fall back to the display's preferred resolution, if the custom value is invalid 
PREFERRED_RESOLUTION=1920x1080
PREFERRED_RATE=60
if [[ ! -z \$PREFERRED_RESOLUTION ]]; then
    current_resolution=\$(xrandr --display :0 | awk 'FNR==1{split(\$0,a,", "); print a[2]}' | awk '{gsub("current ","");gsub(" x ", "x");print}')
    connected_display=\$(xrandr --display :0 | grep " connected " | awk '{ print \$1 }')
    echo "DEBUG: current_resolution: \$current_resolution, connected_display: \$connected_display" >> \$XRANDR_LOG
    echo "DEBUG: preferred_resolution: \$PREFERRED_RESOLUTION @ \$PREFERRED_RATE Hz"
    if \$(xrandr --display :0 | grep -q \$PREFERRED_RESOLUTION); then
        xrandr --display :0 --output \$connected_display --mode \$PREFERRED_RESOLUTION --rate \$PREFERRED_RATE &
    else
        echo "\$PREFERRED_RESOLUTION is not available on \$connected_display.  Remaining at default resolution of \$current_resolution."
    fi
fi

# Disable screen blanking (only happens outside of EmulationStation)
# This prevents the display from doing any ‘screen blanking’ due to inactivity
xset s off && xset -dpms

if [ ! -f /dev/shm/portruncommand.sh ] ; then
    exec openbox-session
else
    ## don't exec; we want to return & exit
    /dev/shm/portruncommand.sh
fi
EOF

chown -v $USER:$USER /home/$USER/.xsession

echo -e "Done\n\n"



