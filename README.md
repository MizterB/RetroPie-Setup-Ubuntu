# RetroPie-Setup-Ubuntu

Script to automate the installation on RetroPie on Ubuntu, with the end-state user experience nearly identical to a Raspberry Pi installation, but with the power and flexibility of x86.

This script was inspired by feedback provided on the [RetroPie forums](https://retropie.org.uk/forum/topic/18810/retropie-installation-on-ubuntu-server-x64-18-04-1), and does the following:

- Disables sudo password prompts
- Installs the minimal OS dependecies needed to install OpenBox and run RetroPie
- Installs the RetroPie 'basic' packages
- Install the latest video drivers for Intel, Nvidia, and Vulkan
- Applies the RetroPie-PacMan Plymouth theme to run during startup / shutdown
- Hides all GRUB and kernel text output during startup/shutdown
- Enables autologin and boots directly into OpenBox / EmulationStation
- Hides all terminal window 'chrome' in OpenBox (menu, scrollbar, cursor) when launching emulators
- Uses 'unclutter' to show the mouse cursor only when it is being moved
- Enables 1080p resolution for GRUB and X Windows to improve the user experience & performance on 4K displays (user configurable)

The script also provides the ability for additional customizations, optionally executing external scripts at the beginning and end of the installation process. A library of user-submitted sctips is available to get you started. See the [Optional Scripts](#optional-scripts) section for more information.

Of course, your mileage may vary when using the master `retropie_setup_ubuntu.sh` script. It has been organized into functions to improve readability. If you don't want to run the full script, you can copy/paste the sections that apply to the specific changes you wish to make. Just note that many of these command would need to be run in `sudo` if executed independently and _variable substitution may be required_.

## Installing the Base OS

### Download a copy of Ubuntu 20.04

These scripts are intended for one of the following Ubuntu 20.04 installations:

- [Live Server](http://releases.ubuntu.com/focal/ubuntu-20.04.1-live-server-amd64.iso)
- [Legacy Server](http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04.1-legacy-server-amd64.iso)
- [Legacy Minimal Install (mini.iso)](http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/mini.iso)

### Manual Ubuntu Install

Perform a basic install of Ubuntu with these basic options

- Language: `english`
- Keyboard: `english`
- Username: `pi`
- Password: `raspberry`
- Partition Scheme: `entire disk` (preferred, not required)
- Optional Install: `openssh-server` (recommended for remote access, copy/paste)

### Automated Ubuntu Install - Live Server

If you are familiar with the use of [autoinstall](https://ubuntu.com/server/docs/install/autoinstall) files to automate Ubuntu installs (no support here), you can use the example [autoinstall-user-data](autoinstall/autoinstall-user-data) file to perform a basic install against the Live Server installer. _Use at your own risk!!!_

### Automated Ubuntu Install - Legacy Mini & Legacy Server

If you are familiar with the use of [preseed](https://help.ubuntu.com/lts/installation-guide/s390x/apbs02.html) files to automate Ubuntu installs (no support here), you can use the example [retropie.preseed](autoinstall/retropie.preseed) file to perform a basic install against the Legacy Server or Mini installer. _Use at your own risk!!!_

## RetroPie-Setup-Ubuntu

- Log in as the `pi` user and run the bootstrap script

  `wget -O - https://raw.githubusercontent.com/MizterB/RetroPie-Setup-Ubuntu/LTS-20.04/bootstrap.sh | sudo bash`

- Configure optional packages, if desired

- Run the installer script as sudo

  `sudo ~/RetroPie-Setup-Ubuntu/retropie_setup_ubuntu.sh`

## Optional Scripts

The main `retropie_setup_ubuntu.sh` script is intended to create a Ubuntu environment that closely mimcs the basic RetroPie image for Raspberry Pi. However, some users have suggested additional tweaks and features that further customize the Ubuntu environment beyond this scope, as well as experimental changes that may be incorporated into the master script in the future. The `optional_scripts` directory provides the ability include these additional changes in the installation process, or to write your own scripts based on your needs.

### The Library

Inside `optional_scripts/library`, you will find a collection of additional scripts that further extend the installation process. While the script names are intended to be descriptive, additional details for each script are included at the beginning of each file.

### Pre-Install and Post-Install Scripts

The `optional_scripts/pre_install` and `optional_scripts/post_install` directories can be populated with BASH scripts that are run at the very beginning and end of the master installation process. Scripts in these directories will be executed in alphabetical order, so if the order is important to you, you can prepend the file names with a number (e.g. `01-myscript.sh`) for greater control.

If you want to include a Library script in your pre or post-install proceess, the easiest way to do this is to simply copy it into the appropriate folder. Alternatively, you can also move the Library scripts or create symbolic links to them.

You can also write your own custom scripts and place them in these directories. Use the scripts in the Library as an example. Note that variables defined in the master script (`USER_HOME`, `SCRIPT_DIR`, etc.) are also available to the custom scripts, and that all output will be automatically written to both the console output and log file.

### Submissions Welcome!

If you have master script changes or additional fetaures that you would like to include in the Library, please share! Pull Requests are preferred.

## CHANGELOG

### 202009xx

- Instructions for multiple 20.04 install methods, including autoinstall example
- New bootstrap installation process
- Customizations possible through pre_install and post_install script directories
- Library of optional scripts
- Logfile is timestamped
- Script runtime is now calculated
- Prevent running as root user, only allow sudo as normal user

### 20200521

- Validated against Ubuntu 20.04 LTS
- Verbose logging to both console and file
- Improved modularity, formatting, and commenting of functions
- Installs the same base packages as the official RetroPie image
- Installs latest Intel video driver
- Option to reboot after install
- Disabled screen blanking
- Safely enable 1080p resolution in GRUB, if available _- user can override resolution in script_
- Safely enable 1080p resolution in X Windows, if available _- user can override resolution in script_

#### MANY THANKS TO [@movisman](https://github.com/movisman) FOR HIS [CODE OPTIMIZATION AND NEW FUNCTIONS](https://github.com/MizterB/RetroPie-Setup-Ubuntu/pull/4)!

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
