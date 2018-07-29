# RaspberryPiSetupScripts
Scripts that allow easy configuration of new raspberry pi test systems. Primary configurations allowed are:
* Change hostname
* Choose boot up mode (CLI/GUI, auto login)
* Setup a samba share called PiShare, sharing the folder /home/pi/pishare
* Setup VNC access
* Provide some helper scripts to start virtual desktop, etc for VNC
* Setup FormulaPi
* Update system
* Auto resize partition

# THESE SCRIPTS ARE FOR TEST/DEVELOPMENT USE ONLY
Note, these scripts contain a hardcoded password which is used for the setup samba shared folder. This is a major security hole. These scripts are purely for configuring test and development systems that are hosted on internal networks.

## Usage
These scripts are designed to provide a quick set of questions and then perform long running actions such as installing libraries, setting up shares, etc.

It can run interactively or silently. When running silently run with the -s parameter. Options available include:
```
-s		Run the setup script silently. Must specify hostname
-f		Setup for Formula Pi
-h NewHostName	The new hostname for this system
-a		Automatically login on boot (default)
-n		No login. Do not login automatically on boot
-c		Boot to commandline
-g		Boot to GUI (default)
```

A primary use case is also allowing automated execution of first boot. By using something like PiBakery you can setup an image to perform actions on first boot. Something like:
* Setup network
* Clone this repo
* Execute SetupPi.sh with parameters

I haven't tested, but ideally this will be a single command like
```
git clone https://github.com/boristsr/RaspberryPiSetupScripts.git && sh RaspberryPiSetupScripts/SetupPi.sh -s -h MyNewHostname -f -g -a
```
This should clone the repo and execute the script with options to:
- Run silently
- Change hostname to MyNewHostname
- Install formula pi libraries
- Boot to GUI
- Login automatically
