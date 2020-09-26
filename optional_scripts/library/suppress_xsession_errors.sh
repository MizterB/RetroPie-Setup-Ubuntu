#!/bin/bash
###############################################################################
# In $HOME/.xsession-errors there are some errors and probably unneeded stuff 
# loaded by openbox (default load).  This script attempts to clean them up.
#
# Also creates an init task that deletes the ~/.xsession-errors file at
# each startup.
#
# Contributor: etherling/johnodon
# Reference: https://retropie.org.uk/forum/post/234008
###############################################################################

echo "--------------------------------------------------------------------------------"
echo "| Suppressing errors in $HOME/.xsession-errors"
echo "--------------------------------------------------------------------------------"
mkdir -p $USER_HOME/.config/autostart
chown -R $USER:$USER $USER_HOME/.config/autostart

mv -v /etc/xdg/autostart/*.desktop /etc/xdg/autostart/*.desktop.skip
## /etc/xdg/autostart/org.gnome.SettingsDaemon.XSettings.desktop must stay or gsettings won't work
mv -v /etc/xdg/autostart/org.gnome.SettingsDaemon.XSettings.desktop.skip /etc/xdg/autostart/org.gnome.SettingsDaemon.XSettings.desktop

# Create init job to delete ~/.xsession-errors at each login
cat << EOF >> /etc/init.d/xsession-errors
#!/bin/sh
rm $USER_HOME/.xsession-errors >/dev/null 2>&1
EOF
chmod +x /etc/init.d/xsession-errors
ln -s /etc/init.d/xsession-errors /etc/rc2.d/S15xsession-errors

echo -e "FINISHED $BASH_SOURCE \n\n"
