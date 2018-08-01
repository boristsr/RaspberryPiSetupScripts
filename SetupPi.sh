#!/bin/bash

usage() {
    echo "Raspberry Pi setup script. Run without parameters for interactive usage";
    echo "-s\t\tRun the setup script silently. Must provide hostname"
    echo "-f\t\tSetup for Formula Pi"
    echo "-h NewHostName\tThe new hostname for this system"
    echo "-a\t\tAutomatically login on boot (default)"
    echo "-n\t\tNo login. Do not login automatically on boot"
    echo "-c\t\tBoot to commandline"
    echo "-g\t\tBoot to GUI (default)"
    echo "Usage: $0 [params]" 1>&2;
    exit 1;
}

silent="false"
setupFormulaPi="false"
autoLogin="true"
bootToGUI="true"
while getopts ":sh:fancg" o; do
    case "${o}" in
        s)
            silent="true"
            ;;
        h)
            newHostname=${OPTARG}
            ;;
        f)
            setupFormulaPi="true"
            ;;
        a)
            autoLogin="true"
            ;;
        n)
            autoLogin="false"
            ;;
        c)
            bootToGUI="false"
            ;;
        g)
            bootToGUI="true"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ "$silent" = "true" ]
then
    echo Running in silent mode
    if [[ -z "$newHostname" ]]
    then
        echo "Error, a hostname must be provided when running silently"
        echo
        usage
        exit 1
    fi
else
    echo Running in interactive mode

    newHostname=""
    if [[ -z "$newHostname" ]]
    then
        echo What is the hostname of this Pi?
        read newHostname 
    fi

    echo
    read -p "Would you like to configure formula pi libraries? (y/N)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        setupFormulaPi="true"
    fi

    echo
    read -p "Would you like to boot to GUI? (Y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
        bootToGUI="false"
    fi

    echo
    read -p "Would you like to automatically login at boot? (Y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
        autoLogin="false"
    fi
fi

echo New hostname will be: $newHostname
echo Setup formula pi: $setupFormulaPi
echo BootToGUI: $bootToGUI
echo Auto login at boot: $autoLogin

#https://www.raspberrypi.org/forums/viewtopic.php?p=1160522&sid=f93dad2f4e19c6959fdd41ba367defe0#p1160522
#define SET_BOOT_CLI    "sudo raspi-config nonint do_boot_behaviour B1"
#define SET_BOOT_CLIA   "sudo raspi-config nonint do_boot_behaviour B2"
#define SET_BOOT_GUI    "sudo raspi-config nonint do_boot_behaviour B3"
#define SET_BOOT_GUIA   "sudo raspi-config nonint do_boot_behaviour B4"
bootMode=1
if [ "$bootToGUI" = "true" ]
then
    if [ "$autoLogin" = "true" ]
    then
        bootMode=4
    else
        bootMode=3
    fi
else
    if [ "$autoLogin" = "true" ]
    then
        bootMode=2
    else
        bootMode=1
    fi
fi

# do hostname config
#https://github.com/davidferguson/pibakery/blob/master/pibakery-blocks/sethostname/sethostname.sh
raspi-config nonint do_hostname "$newHostname"
hostname -b "$newHostname"
systemctl restart avahi-daemon

#expand filesystem
#should automatically happen with raspbian, so disabled for now
#https://raspberrypi.stackexchange.com/questions/28907/how-could-one-automate-the-raspbian-raspi-config-setup
#raspi-config nonint do_expand_rootfs

echo Updating Apt
#setup apt
apt-get update

echo Performing dist-upgrade
#upgrade and distupgrade
apt-get -y --force-yes dist-upgrade
echo Dist-upgrade complete

#enable vnc
raspi-config nonint do_vnc 1
echo VNC enabled

#enable vnc
raspi-config nonint do_ssh 1
echo SSH enabled

raspi-config nonint do_boot_behaviour B$bootMode
echo Bootmode configured to B$bootMode

#setup samba
sh SetupSamba.sh
echo Samba configured with development share

if [ "$setupFormulaPi" = "true" ]
then
    sh SetupFormulaPi-S2018.sh
    echo FormulaPi configured
fi

echo ========================================
echo Done!
echo It is highly recommended to reboot now
echo ========================================
