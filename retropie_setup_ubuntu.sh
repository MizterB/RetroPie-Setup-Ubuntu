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
    echo "- Update OS packages and install RetroPie dependencies"
    echo "--------------------------------------------"
    apt-get update && apt-get -y upgrade
    apt-get -y install ${RETROPIE_CORE_DEPENDS[@]} ${RETROPIE_EXTRA_DEPENDS[@]}
}

#Install RetroPie
function install_retropie() {
    echo "--------------------------------------------"
    echo "- Installing RetroPie"
    echo "--------------------------------------------"
    # Get Retropie Setup script and perform a basic install with Samba
    # NOTE: Installing the 'core' packages individually creates issues, use basic_install instead
    cd $USER_HOME
    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    $USER_HOME/RetroPie-Setup/retropie_packages.sh setup basic_install
    $USER_HOME/RetroPie-Setup/retropie_packages.sh samba
    $USER_HOME/RetroPie-Setup/retropie_packages.sh samba install_shares
    chown -R $USER:$USER $USER_HOME/RetroPie-Setup
}

# Add Retroarch Shaders from official repository
function add_retroarch_shaders() {
    echo "--------------------------------------------"
    echo "- Remove Pi shaders installed by RetroPie-Setup"
    echo "- then merge common shaders & GLSL shaders"
    echo "- into RetroArch (from Libretro repository)"
    echo "--------------------------------------------"
    # Cleanup pi shaders installed by RetroPie-Setup
    rm -rf /opt/retropie/configs/all/retroarch/shaders
    mkdir -p /opt/retropie/configs/all/retroarch/shaders
    # Install common shaders from Libretro repository
    git clone --depth=1 https://github.com/libretro/common-shaders.git /tmp/common-shaders
    cp -r /tmp/common-shaders/* /opt/retropie/configs/all/retroarch/shaders/
    rm -rf /tmp/common-shaders
    # Install GLSL shaders from Libretro repository
    git clone --depth=1 https://github.com/libretro/glsl-shaders.git /tmp/glsl-shaders
    cp -r /tmp/glsl-shaders/* /opt/retropie/configs/all/retroarch/shaders/
    rm -rf /tmp/glsl-shaders
    # Remove git repository from shader dir
    rm -rf /opt/retropie/configs/all/retroarch/shaders/.git
    chown -R $USER:$USER /opt/retropie/configs
}

# Install latest Intel video drivers
function install_latest_intel_drivers() {
    echo "--------------------------------------------"
    echo "- Installing the latest intel drivers"
    echo "--------------------------------------------"
    add-apt-repository -y ppa:ubuntu-x-swat/updates
    apt-get update && apt-get -y upgrade
}

# Install MESA Vulkan drivers
function install_vulkan() {
    echo "--------------------------------------------"
    echo "- Installing Vulkan"
    echo "--------------------------------------------"
    apt-get -y install mesa-vulkan-drivers
}

# Hide Boot Messages
function hide_boot_messages() {
    echo "--------------------------------------------"
    echo "- Hiding boot messages"
    echo "--------------------------------------------"
    # Hide kernel messages and blinking cursor via GRUB
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=".*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vt.global_cursor_default=0"/g' /etc/default/grub
    update-grub

    # Hide fsck messages after Plymouth splash
    echo 'FRAMEBUFFER=y' > /etc/initramfs-tools/conf.d/splash
    update-initramfs -u

    # Remove cloud-init to suppress its boot messages
    apt-get purge cloud-init -y
    rm -rf /etc/cloud/ /var/lib/cloud/

    # Disable motd
    touch $USER_HOME/.hushlogin
    chown $USER:$USER $USER_HOME/.hushlogin
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

# Enable Plymouth Splash Screen
function enable_plymouth_theme() {
    echo "--------------------------------------------"
    echo "- Enabling Plymouth themes"
    echo "--------------------------------------------"
    apt-get -y install plymouth plymouth-themes plymouth-x11
    rm -rf /tmp/plymouth-themes
    git clone --depth=1 https://github.com/HerbFargus/plymouth-themes.git /tmp/plymouth-themes
    mv /tmp/plymouth-themes/* /usr/share/plymouth/themes/
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/$PLYMOUTH_THEME/$PLYMOUTH_THEME.plymouth 10
    update-alternatives --set default.plymouth /usr/share/plymouth/themes/$PLYMOUTH_THEME/$PLYMOUTH_THEME.plymouth
    update-initramfs -u
}

# Hide Openbox Windows and reduce visibility of terminal
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
    chown -R $USER:$USER $USER_HOME/.config
}

# Start X as soon as autologin is complete
function enable_autostart_xwindows() {
    echo "--------------------------------------------"
    echo "- Enabling autostart of XWindows"
    echo "--------------------------------------------"
    # Create a .xsession file to launch OpenBox when startx is called
    echo 'exec openbox-session' >> $USER_HOME/.xsession
    chown $USER:$USER $USER_HOME/.xsession

    # Add startx to .bash_profile
    cat << EOF >> $USER_HOME/.bash_profile
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
    startx -- >/dev/null 2>&1
fi
EOF
    chown $USER:$USER $USER_HOME/.bash_profile
}

# Autostart Openbox Applications
function autostart_openbox_apps() {
    echo "--------------------------------------------"
    echo "- Enabling OpenBox autostart applications and RetroPie autostart.sh"
    echo "--------------------------------------------"
    # OpenBox autostarts unclutter, then passes off to the RetroPie autostart
    mkdir -p $USER_HOME/.config/openbox
    echo 'unclutter -idle 0.01 -root' >> $USER_HOME/.config/openbox/autostart
    echo '/opt/retropie/configs/all/autostart.sh' >> $USER_HOME/.config/openbox/autostart
    chown -R $USER:$USER $USER_HOME/.config
    # Create RetroPie autostart
    mkdir -p /opt/retropie/configs/all
    touch /opt/retropie/configs/all/autostart.sh
    chmod +x /opt/retropie/configs/all/autostart.sh
    chown -R $USER:$USER /opt/retropie/configs
    cat << EOF > /opt/retropie/configs/all/autostart.sh
#! /bin/bash

###############################################################################
# Start EmulationStation
###############################################################################
gnome-terminal --full-screen --hide-menubar -- emulationstation --no-splash
EOF
}

# Install Latest Nvidia Drivers
function install_latest_nvidia_drivers() {
    echo "--------------------------------------------"
    echo "- Install Latest Nvidia Drivers"
    echo "--------------------------------------------"
    apt-get -y install ubuntu-drivers-common
    add-apt-repository -y ppa:graphics-drivers/ppa
    ubuntu-drivers autoinstall
}

# Disable screen blanking (only happens outside of EmulationStation)
function disable_screen_blanking() {
    echo "--------------------------------------------"
    echo "- Disable screen blanking (only happens outside of EmulationStation)"
    echo "- Stops the display from doing any ‘screen blanking’"
    echo "- after a short period of activity"
    echo "--------------------------------------------"
    sed -i '1 i\xset s off && xset -dpms' $USER_HOME/.xsession
}

# Change GRUB Graphics Mode to higher resolution
# Beware using this function!
function change_grub_gfxmode() {
    echo "--------------------------------------------"
    echo "- Change GRUB Graphics Mode from default"
    echo "- Only use if supported!"
    echo "- Run vbeinfo or videoinfo from GRUB"
    echo "- command line to see supported modes"
    echo "- Change the resolution to one which is supported"
    echo "--------------------------------------------"
    sed -i 's/#GRUB_GFXMODE=.*/GRUB_GFXMODE=1920x1080x32/g' /etc/default/grub
    update-grub
}

# Fix permissions function recursively on $USER_HOME directory
function fix_home_permissions() {
    echo "--------------------------------------------"
    echo "- Fix any snags relating to file/folder permissions underneath $USER_HOME"
    echo "- Change owner to $USER on all files and directories under $USER_HOME"
    echo "--------------------------------------------"
    chown -R $USER:$USER $USER_HOME/
}

# Cleanup unneeded packages
function cleanup_unneeded_packages() {
    echo "--------------------------------------------"
    echo "- Final update and cleanup unneeded packages"
    echo "--------------------------------------------"
    apt-get update && apt-get -y upgrade
    apt-get -y autoremove
}

# Download RetroPie only - do not install
function download_retropie_only() {
    echo "--------------------------------------------"
    echo "- Downloading RetroPie"
    echo "--------------------------------------------"
    # Get Retropie Setup script
    cd $USER_HOME
    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    chown -R $USER:$USER $USER_HOME/RetroPie-Setup
}

# Force this script to run as root
[ `whoami` = root ] || { sudo "$0" "$@"; exit $?; }

# Execute OS Steps and dependencies
disable_sudo_password
install_retropie_dependencies
install_retropie
install_latest_intel_drivers
install_vulkan
add_retroarch_shaders
hide_boot_messages
enable_autologin_tty
enable_plymouth_theme
hide_openbox_windows
enable_autostart_xwindows
autostart_openbox_apps

# Optional steps (uncomment as needed)
install_latest_nvidia_drivers
disable_screen_blanking
change_grub_gfxmode

# Final cleanup
fix_home_permissions
cleanup_unneeded_packages

# retropie download only, do not install it
# comment out the install_retropie function above and uncomment the below function to use this
# useful if you want to install retropie components yourself rather than run a basic install
#download_retropie_only