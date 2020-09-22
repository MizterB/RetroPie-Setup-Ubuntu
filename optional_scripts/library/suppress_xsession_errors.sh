#!/bin/bash
###############################################################################
# In $HOME/.xsession-errors there are some errors and probably unneeded stuff 
# loaded by openbox (default load).  This script attempts to clean them up.
#
# Contributor: etherling
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Suppressing errors in $HOME/.xsession-errors"
echo "--------------------------------------------------------------------------------"
mkdir -p $USER_HOME/.config/autostart

mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Sound.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Sound.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop.skip
mv -v /etc/xdg/autostart/gnome-keyring-secrets.desktop /etc/xdg/autostart/gnome-keyring-secrets.desktop.skip
mv -v /etc/xdg/autostart/gnome-keyring-pkcs11.desktop /etc/xdg/autostart/gnome-keyring-pkcs11.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop /etc/xdg/autostart/org.gnome.Evolution-alarm-notify.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.MediaKeys.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.MediaKeys.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Wwan.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Wwan.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.ScreensaverProxy.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.ScreensaverProxy.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.A11ySettings.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.A11ySettings.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.UsbProtection.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.UsbProtection.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Housekeeping.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Housekeeping.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Power.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Power.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Rfkill.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Rfkill.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Datetime.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Datetime.desktop.skip
## edit: this is needed (or otherwise gsettings won't work)    
## mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.XSettings.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.XSettings.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Keyboard.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Keyboard.desktop.skip
mv -v /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.PrintNotifications.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.PrintNotifications.desktop.skip
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.Color.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.Color.desktop.skip
mv -v /etc/xdg/autostart/at-spi-dbus-bus.desktop /etc/xdg/autostart/at-spi-dbus-bus.desktop.skip
mv -v /etc/xdg/autostart/gnome-shell-overrides-migration.desktop /etc/xdg/autostart/gnome-shell-overrides-migration.desktop.skip
mv -v /etc/xdg/autostart/nm-applet.desktop /etc/xdg/autostart/nm-applet.desktop.skip
## pulseaudio.desktop ; # lets keep this for now                                                                                                             
mv -v /etc/xdg/autostart/xdg-user-dirs.desktop /etc/xdg/autostart/xdg-user-dirs.desktop.skip
mv -v /etc/xdg/autostart/geoclue-demo-agent.desktop /etc/xdg/autostart/geoclue-demo-agent.desktop.skip
mv -v /etc/xdg/autostart/im-launch.desktop /etc/xdg/autostart/im-launch.desktop.skip
mv -v /etc/xdg/autostart/print-applet.desktop /etc/xdg/autostart/print-applet.desktop.skip
mv -v /etc/xdg/autostart/snap-userd-autostart.desktop /etc/xdg/autostart/snap-userd-autostart.desktop.skip

echo -e "FINISHED $BASH_SOURCE \n\n"
