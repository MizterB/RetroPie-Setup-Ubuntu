# RetroPie-Setup-Ubuntu

Script to automate the installation on RetroPie on Ubuntu, with the end-state user experience nearly identical to a Raspberry Pi installation, but with the power and flexibility of x86.

This script was inspired by feedback provided on the [RetroPie forums](https://retropie.org.uk/forum/topic/18810/retropie-installation-on-ubuntu-server-x64-18-04-1), and does the following:
- Disables sudo password prompts
- Installs the minimal OS dependecies needed to install OpenBox and run RetroPie
- Installs the RetroPie 'core' modules (it does not install any emulators - you can run Retropie Setup later to configure as needed)
- Install the latest video drivers for Intel, Nvidia, and Vulkan
- Applies the RetroPie-PacMan Plymouth theme to run during startup / shutdown
- Hides all GRUB and kernel text output during startup/shutdown
- Enables autologin and boots directly into OpenBox / EmulationStation
- Hides all terminal window 'chrome' in OpenBox (menu, scrollbar, cursor) when launching emulators
- Uses 'unclutter' to show the mouse cursor only when it is being moved
- Enables 1080p resolution for GRUB and X Windows to improve the user experience & performance on 4K displays (user configurable)

Of course, your mileage may vary when using this script.  I have organized it into functions to improve readability.  If you don't want to run the full script, you can copy/paste the sections that apply to the specific changes you wish to make.  Just note that many of these command would need to be run in `sudo` if executed independently and *variable substitution may be required*.

## Installing the Base OS
### Manual Install
- Perform a basic install of Ubuntu Server or Ubuntu Mini (this was tested on 18.04 and 20.04 LTS) using default options
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
  
  `wget "https://raw.githubusercontent.com/MizterB/RetroPie-Setup-Ubuntu/LTS-20.04/retropie_setup_ubuntu.sh"`

- Make the file executable
  
  `chmod +x ./retropie_setup_ubuntu.sh`

- Run as root
  
  `sudo ./retropie_setup_ubuntu.sh`

## Single Step Install Method
- Log in as the `pi` user and download a local copy of this script:
  
  `wget -O - https://raw.githubusercontent.com/MizterB/RetroPie-Setup-Ubuntu/LTS-20.04/retropie_setup_ubuntu.sh | sudo bash`

## TODO
- Check if changes have already been applied, so they are not duplicated if the script is run a second time

## CHANGELOG
### 20200521
- Validated against Ubuntu 20.04 LTS
- Verbose logging to both console and file
- Improved modularity, formatting, and commenting of functions
- Installs latest Intel video driver
- Option to reboot after install
- Disabled screen blanking
- Safely enable 1080p resolution in GRUB, if available *- user can override resolution in script*
- Safely enable 1080p resolution in X Windows, if available *- user can override resolution in script*
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
