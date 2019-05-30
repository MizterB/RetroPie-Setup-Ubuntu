# RetroPie-Setup-UbuntuServer
Script to automate the installation on RetroPie on Ubuntu Server, with the end-state user experience nearly identical to a Raspberry Pi installation, but with the power and flexibility of x86.

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

## Usage (Tested Steps)
- Perform a basic install of Ubuntu Server (this was tested on 18.04.2 LTS) using default options
  - Language: `english`
  - Keyboard: `english`
  - Username: `pi` 
  - Password: `raspberry`
  - Partition Scheme: `entire disk` (preferred, not required)
  - Optional Install: `openssh-server` (recommended for remote access, copy/paste)

- Log in as the `pi` user and download a local copy of this script:
  
  `curl -O https://raw.githubusercontent.com/MizterB/RetroPie-Setup-UbuntuServer/master/retropie_setup_ubuntuserver.sh`

- Make the file executable
  
  `chmod +x ./retropie_setup_ubuntuserver.sh`

- Run as root
  
  `sudo ./retropie_setup_ubuntuserver.sh`

## TODO
- Improve configurability (run with options)
- Check if changes have already been applied, so they are not duplicated if the script is run a second time