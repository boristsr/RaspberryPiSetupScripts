#!/bin/bash

bash <(curl https://www.piborg.org/installer/install-thunderborg.txt)

apt-get -y install ftp
apt-get -y install python-picamera
apt-get -y install libcv-dev libopencv-dev python-opencv

#enable I2C
raspi-config nonint do_i2c 1
#enable pi camera
raspi-config nonint do_camera 1

mkdir /home/pi/formulapi
chown -R pi:pi /home/pi/formulapi
chmod -R 755 /home/pi/formulapi

echo [formulapi] >> /etc/samba/smb.conf
echo  comment=FormulaPi Share >> /etc/samba/smb.conf
echo  path=/home/pi/formulapi >> /etc/samba/smb.conf
echo  browseable=Yes >> /etc/samba/smb.conf
echo  writeable=Yes >> /etc/samba/smb.conf
echo  only guest=No >> /etc/samba/smb.conf
echo  create mask=0777 >> /etc/samba/smb.conf
echo  directory mask=0777 >> /etc/samba/smb.conf
echo  public=no >> /etc/samba/smb.conf
