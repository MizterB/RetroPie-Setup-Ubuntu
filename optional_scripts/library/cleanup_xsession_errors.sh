#!/bin/bash
###############################################################################
# Cleanup items that cause consistent errors to be written to the
# ~/.xsession-errors file.
#
# Also creates an init task that deletes the ~/.xsession-errors file at
# each startup.
#
# Contributor: johnodon
# Reference: n/a
###############################################################################
echo "--------------------------------------------------------------------------------"
echo "| Cleans up items that generate xsessions errors (~/.xsession-errors)."
echo "| Also creating an init job that deletes the ~/.xsession-errors file at each"
echo "| reboot so we are starting with a clean file."
echo "--------------------------------------------------------------------------------"

# Remove all files from /etc/xdg/autostart
rm /etc/xdg/autostart/*

# Create ~/.config/autostart folder
mkdir -p $USER_HOME/.config/autostart
chown -R $USER:$USER $USER_HOME/.config/autostart

# Create init job to delete ~/.xsession-errors at each login
cat << EOF >> /etc/init.d/xsession-errors
#!/bin/sh
rm $USER_HOME/.xsession-errors >/dev/null 2>&1
EOF
chmod +x /etc/init.d/xsession-errors
ln -s /etc/init.d/xsession-errors /etc/rc2.d/S15xsession-errors

echo -e "FINISHED $BASH_SOURCE \n\n"
