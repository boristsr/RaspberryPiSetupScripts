#!/bin/bash

apt-get install samba

mkdir /home/pi/share
chown -R pi:pi /home/pi/share
chmod -R 755 /home/pi/share

echo [PiShare] >> /etc/samba/smb.conf
echo  comment=Raspi Share >> /etc/samba/smb.conf
echo  path=/home/pi/share >> /etc/samba/smb.conf
echo  browseable=Yes >> /etc/samba/smb.conf
echo  writeable=Yes >> /etc/samba/smb.conf
echo  only guest=No >> /etc/samba/smb.conf
echo  create mask=0777 >> /etc/samba/smb.conf
echo  directory mask=0777 >> /etc/samba/smb.conf
echo  public=no >> /etc/samba/smb.conf

(echo pishare; echo pishare) | smbpasswd -s -a pi
