#!/bin/bash

#from here
#https://github.com/justinisamaker/ansible-pi

# Make a copy of the locale file before we edit it
cp /etc/locale.gen /etc/local.gen.dist

# Comment out the en_GB entry in the locale file
sed -i -e 's/en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/g' /etc/locale.gen

# Uncomment the en_AU entry in the locale file
sed -i -e 's/# en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/g' /etc/locale.gen

# gen the locale
locale-gen

# replace the locale in the debconf dir
sed -i -e 's/en_GB/en_AU/g' /var/cache/debconf/config.dat

# update lang in /etc/default/locale
sed -i -e 's/en_GB/en_AU/g' /etc/default/locale

# set the keyboard layout
sed -i -e 's/gb/us/g' /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration
dpkg-reconfigure -f noninteractive console-setup

# Set time zone and time 
echo "Australia/Sydney" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata