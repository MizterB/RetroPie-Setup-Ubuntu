# RetroPie-Setup-Ubuntu
Script to automate the installation on RetroPie on Ubuntu, with the end-state user experience nearly identical to a Raspberry Pi installation, but with the power and flexibility of x86.

This script was inspired by feedback provided on the [RetroPie forums](https://retropie.org.uk/forum/topic/18810/retropie-installation-on-ubuntu-server-x64-18-04-1), and does the following:
- Disables sudo password prompts
- Installs the minimal OS dependecies needed to install OpenBox and run RetroPie
- Installs the RetroPie 'core' modules (it does not install any emaulators - you can run Retropie Setup later to configure as needed)
- Hides all GRUB and kernel text output during startup/shutdown
- Applies the RetroPie-PacMan Plymouth theme to run during startup / shutdown
- Enables autologin and boots directly into OpenBox / EmulationStation
- Hides all terminal window 'chrome' in OpenBox (menu, scrollbar, cursor) when launching emulators
- Uses 'unclutter' to show the mouse cursor only when it is being moved

Of course, your mileage may vary when using this script.  I have organized it into functions to improve readability.  If you don't want to run the full script, you can copy/paste the sections that apply to the specific changes you wish to make.  Just note that many of these command would need to be run in `sudo` if executed independently and *variable substitution may be required*.

## Installing the Base OS
### Manual Install
- Perform a basic install of Ubuntu Server or Ubuntu Mini (this was tested on 18.04.2 LTS) using default options
  - Language: `english`
  - Keyboard: `english`
  - Username: `pi` 
  - Password: `raspberry`
  - Partition Scheme: `entire disk` (preferred, not required)
  - Optional Install: `openssh-server` (recommended for remote access, copy/paste)
### Automated Preseed Install
If you are familiar with the use of Preseed files to automate Ubuntu installs (no support here), you can use the included `retropie.preseed` to perform a basic install against a Server or Mini installer.

## Installing RetroPie
- Log in as the `pi` user and download a local copy of this script:
  
  `wget "https://raw.githubusercontent.com/MizterB/RetroPie-Setup-Ubuntu/master/retropie_setup_ubuntu.sh"`

- Make the file executable
  
  `chmod +x ./retropie_setup_ubuntu.sh`

- Run as root
  
  `sudo ./retropie_setup_ubuntu.sh`


## Single Step Install Method
- Log in as the `pi` user and download a local copy of this script:
  
  `wget -O - https://raw.githubusercontent.com/MizterB/RetroPie-Setup-UbuntuServer/master/retropie_setup_ubuntu.sh | sudo bash`

## TODO
- Improve configurability (run with options)
- Check if changes have already been applied, so they are not duplicated if the script is run a second time

## CHANGELOG
### 20200222
### Existing Functions:
#### function install_retropie_dependencies
- remove -no-install-recommends as having this causes a blank screen on boot for nvidia cards when using a proprietary driver
#### function add_retroarch_shaders
- add line of code to remove the 'pi' centered shaders directory installed by RetroPie-Setup
- recreate the shaders directory afresh
- add chown command at the end of the function to make sure everything under /opt/retropie/configs is owned by $USER
#### function hide_boot_messages
- improve logic on sed command so instead of relying on GRUB_CMDLINE_LINUX_DEFAULT having the value "quiet" or "" to make the changes needed, now it will replace whatever exists in the quotes with the intended attributes.
#### function enable_plymouth_theme
- remove -no-install-recommends just in case it causes issues.
#### function hide_openbox_windows
- remove $(cat $USER_HOME/.bash_profile) just before EOF, as this causes the 'startx' code to appear twice in .bash_profile (once at the top, and once below the gnome-terminal commands)
- reorder this function so it takes place before enable_autostart_xwindows - this ensures that the gnome-terminal code is run before startx is called
- changed chown command so it changes ownership to $USER from .config recursively instead of .config/openbox - this resolves an issue where .config/dconf (which gets created when gnome-terminal is first launched) is incorrectly owned by root - this then causes DCONF console errors for the gnome-terminal customisation when .bash_profile is called, resulting in no customisation happening because it cannot write to the file correctly (presumably because it is owned by root). Changing the chown command totally resolves this problem, resulting in fully customised black and green terminal with no bars etc.
#### function enable_autostart_xwindows
- change ~/ on several lines to $USER_HOME/ to match other functions
#### function autostart_openbox_apps
- changed chown command to /opt/retropie/configs recursively instead of just changing ownership on autostart.sh, otherwise some of the directories get owned by root again. opt/retropie/configs and all files/folders beneath should be owned by $USER
#### function install_vulkan
- remove -no-install-recommends just in case it causes issues
### New Functions:
added optional functions (not enabled by default) for:
- installing the latest nvidia driver
- disabling screen blanking
- changing the GRUB graphics mode to 1920x1080x32 for nicer splash (if supported)
- final apt update/upgrade and cleanup unneeded packages (autoremove)
- offer to reboot once last function is completed
- fix permissions function which catches any potential snags where folders or files under $USER_HOME may get owned by root.
- downloading retropie only (you need to comment out executing install_retropie in order to use this)
### Misc:
- added logging at top of file so console output is stored as retropie_setup_ubuntu.log when complete
- reordered functions to match the order they execute in
- reordered the execution of functions to resolve a couple of minor issues
- add titles to all functions to tidy up a bit, add additional descriptions/info

### 20190728
- Changed name to reflect support for both Server and Mini versions of Ubuntu
- Addded `retropie.preseed` file to standardize basic OS install & config
- Installs the basic_install RetroPie meta-package, rather than its individual parts
- Improved hiding of boot messages
- Updated autostart logic, moved EmaulationStation launch into RetroPie's autostart.sh file
- Enabled install of updated video drivers and Vulkan by default
- Removed install of Ultimarc-linux and RetroPie launchingimages package.

### 20190530
- Initial release
