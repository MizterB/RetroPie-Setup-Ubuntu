#! /bin/bash

USER=pi
USER_HOME=/home/$USER

PLYMOUTH_THEME=retropie-pacman

RETROPIE_CORE_DEPENDS=(
    xorg openbox pulseaudio alsa-utils menu libglib2.0-bin python-xdg 
    at-spi2-core libglib2.0-bin dbus-x11 git dialog unzip xmlstarlet
)
RETROPIE_EXTRA_DEPENDS=( 
    openssh-server xdg-utils unclutter 
)

# Add user to sudoers file and disable password prompt
function disable_sudo_password() {
    echo "--------------------------------------------"
    echo "- Disabling the sudo password prompt"
    echo "--------------------------------------------"
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
}

# Install RetroPie dependencies
function install_retropie_dependencies() {
    echo "--------------------------------------------"
    echo "- Installing RetroPie dependencies"
    echo "--------------------------------------------"
    apt-get update && apt-get -y upgrade
    apt-get -y install --no-install-recommends ${RETROPIE_CORE_DEPENDS[@]} ${RETROPIE_EXTRA_DEPENDS[@]}
}

function install_latest_video_drivers() {
    echo "--------------------------------------------"
    echo "- Installing the latest video drivers"
    echo "--------------------------------------------"
    add-apt-repository -y ppa:ubuntu-x-swat/updates
    apt-get update && apt-get -y upgrade
}

function install_vulkan() {
    echo "--------------------------------------------"
    echo "- Installing Vulkan"
    echo "--------------------------------------------"
    apt-get -y install --no-install-recommends mesa-vulkan-drivers
}

function install_retropie_core() {
    echo "--------------------------------------------"
    echo "- Installing RetroPie core modules"
    echo "--------------------------------------------"
# Get Retropie Setup script and perform a basic install with Samba
    cd $USER_HOME
    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    $USER_HOME/RetroPie-Setup/retropie_packages.sh setup basic_install
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh retroarch
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh emulationstation 
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh retropiemenu
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh runcommand
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh samba
    #$USER_HOME/RetroPie-Setup/retropie_packages.sh samba install_shares
    chown -R $USER:$USER $USER_HOME/RetroPie-Setup
}

# Configure 'pi' user to autologin
function enable_autologin_tty() {
    echo "--------------------------------------------"
    echo "- Enabling autologin to console"
    echo "--------------------------------------------"
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat << EOF >> /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --skip-login --noissue --autologin $USER %I \$TERM
Type=idle
EOF
}

# Start X as soon as autologin is complete
function enable_autostart_xwindows() {
    echo "--------------------------------------------"
    echo "- Enabling autostart of XWindows"
    echo "--------------------------------------------"
    
    # Create a .xsession file to launch OpenBox when startx is called
    echo 'exec openbox-session' >> ~/.xsession
    chown $USER:$USER ~/.xsession

    # Add startx to .bash_profile
    cat << EOF >> ~/.bash_profile
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
    #startx -- -nocursor >/dev/null 2>&1
    startx -- >/dev/null 2>&1
fi
EOF
    chown $USER:$USER ~/.bash_profile
}

function hide_boot_messages() {
    echo "--------------------------------------------"
    echo "- Hiding boot messages"
    echo "--------------------------------------------"
    # Hide kernel messages and blinking cursor via GRUB
    sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vt.global_cursor_default=0"/g' /etc/default/grub
    sudo update-grub

    # Remove cloud-init to supress its boot messages
    apt-get purge cloud-init -y
    rm -rf /etc/cloud/ /var/lib/cloud/

    # Disable motd
    touch $USER_HOME/.hushlogin
    chown $USER:$USER $USER_HOME/.hushlogin
}

function enable_plymouth_theme() {
    echo "--------------------------------------------"
    echo "- Enabling Plymouth themes"
    echo "--------------------------------------------"
    apt-get -y install --no-install-recommends plymouth plymouth-themes plymouth-x11
    rm -rf /tmp/plymouth-themes
    git clone --depth=1 https://github.com/HerbFargus/plymouth-themes.git /tmp/plymouth-themes
    mv /tmp/plymouth-themes/* /usr/share/plymouth/themes/
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/$PLYMOUTH_THEME/$PLYMOUTH_THEME.plymouth 10
    update-alternatives --set default.plymouth /usr/share/plymouth/themes/$PLYMOUTH_THEME/$PLYMOUTH_THEME.plymouth
    update-initramfs -u
}

function hide_openbox_windows() {
    echo "--------------------------------------------"
    echo "- 'Hiding' OpenBox windows"
    echo "--------------------------------------------"
    # Reduce the visibility of the gnome terminal by prepending these settings in the bash profile
    GNOME_TERMINAL_SETTINGS='dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/'
    cat << EOF >> $USER_HOME/.bash_profile
$GNOME_TERMINAL_SETTINGS use-theme-colors false
$GNOME_TERMINAL_SETTINGS use-theme-transparency false
$GNOME_TERMINAL_SETTINGS default-show-menubar false
$GNOME_TERMINAL_SETTINGS foreground-color '#FFFFFF'
$GNOME_TERMINAL_SETTINGS background-color '#000000'
$GNOME_TERMINAL_SETTINGS cursor-blink-mode 'off'
$GNOME_TERMINAL_SETTINGS scrollbar-policy 'never'
$GNOME_TERMINAL_SETTINGS audible-bell 'false'
$(cat $USER_HOME/.bash_profile)
EOF
    chown $USER:$USER $USER_HOME/.bash_profile

    # Further reduce the visibility of windows (terminal) by modifying the OpenBox config
    mkdir -p $USER_HOME/.config/openbox
    cp /etc/xdg/openbox/rc.xml $USER_HOME/.config/openbox/rc.xml
    cat << EOF > /tmp/rc.xml.applications
        <application class="*">
            <fullscreen>yes</fullscreen>
            <iconic>no</iconic>
            <layer>below</layer>
            <decor>no</decor>
            <maximized>true</maximized>
        </application>
EOF
    sed -i '/<applications>/r /tmp/rc.xml.applications' $USER_HOME/.config/openbox/rc.xml
    rm /tmp/rc.xml.applications
    sed -e 's/<keepBorder>yes<\/keepBorder>/<keepBorder>no<\/keepBorder>/g' -i $USER_HOME/.config/openbox/rc.xml
    chown -R $USER:$USER $USER_HOME/.config/openbox
}

function autostart_openbox_apps() {
    echo "--------------------------------------------"
    echo "- Enabling OpenBox autostart applications and RetroPie autostart.sh"
    echo "--------------------------------------------"
    # OpenBox autostarts unclutter, then passes off to the RetroPie autostart
    mkdir -p $USER_HOME/.config/openbox
    echo 'unclutter -idle 0.01 -root' >> $USER_HOME/.config/openbox/autostart
    echo '/opt/retropie/configs/all/autostart.sh' >> $USER_HOME/.config/openbox/autostart 
    chown -R $USER:$USER $USER_HOME/.config/openbox
    # Create RetroPie autostart
    touch /opt/retropie/configs/all/autostart.sh
    chmod +x /opt/retropie/configs/all/autostart.sh
    chown $USER:$USER /opt/retropie/configs/all/autostart.sh
    echo 'gnome-terminal --full-screen --hide-menubar -- emulationstation --no-splash' >> /opt/retropie/configs/all/autostart.sh
}

function add_retroarch_shaders() {
    echo "--------------------------------------------"
    echo "- Merging common shaders & GLSL shaders"
    echo "- into to RetroArch"
    echo "--------------------------------------------"
    # Common shaders
    git clone --depth=1 https://github.com/libretro/common-shaders.git /tmp/common-shaders
    cp -r /tmp/common-shaders/* /opt/retropie/configs/all/retroarch/shaders/
    rm -rf /tmp/common-shaders
    # GLSL shaders
    git clone --depth=1 https://github.com/libretro/glsl-shaders.git /tmp/glsl-shaders
    cp -r /tmp/glsl-shaders/* /opt/retropie/configs/all/retroarch/shaders/
    rm -rf /tmp/glsl-shaders
}

function install_ultimarc_linux() {
    echo "--------------------------------------------"
    echo "- Installing Ultimarc tools for Linux"
    echo "--------------------------------------------"

    # Dependencies
    apt-get -y install autoconf libudev-dev libjson-c-dev libusb-1.0-0-dev libtool
    git clone --depth=1 https://github.com/katie-snow/Ultimarc-linux.git /tmp/ultimarc-linux
    cd /tmp/ultimarc-linux
    ./autogen.sh
    ./configure
    make
    mkdir -p /opt/retropie/supplementary/ultimarc-linux/examples
    cp /tmp/ultimarc-linux/21-ultimarc.rules /etc/udev/rules.d/
    cp -r /tmp/ultimarc-linux/src/umtool/.deps /opt/retropie/supplementary/ultimarc-linux/
    cp -r /tmp/ultimarc-linux/src/umtool/.libs /opt/retropie/supplementary/ultimarc-linux/
    cp /tmp/ultimarc-linux/src/umtool/umtool /opt/retropie/supplementary/ultimarc-linux/
    cp /tmp/ultimarc-linux/src/umtool/*.json /opt/retropie/supplementary/ultimarc-linux/examples/
}

install_runcommand_launchingimages() {
    echo "--------------------------------------------"
    echo "- Installing launching images for runcommand"
    echo "--------------------------------------------"

    $USER_HOME/RetroPie-Setup/retropie_packages.sh launchingimages
}

# Force this script to run as root
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }

# Execute these steps
disable_sudo_password
install_retropie_dependencies
install_retropie_core
hide_boot_messages
enable_autologin_tty
enable_autostart_xwindows
enable_plymouth_theme
hide_openbox_windows
autostart_openbox_apps
install_latest_video_drivers
install_vulkan
add_retroarch_shaders
install_ultimarc_linux
install_runcommand_launchingimages