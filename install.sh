#!/bin/bash
set -e
if [ `whoami` = root ]; then
    echo Please do not run this script as root or using sudo
    exit 1
fi

TOPDIR="`pwd`"

#install dependancies
sudo apt-get install build-essential cmake libfftw3-dev libusb-1.0-0-dev curl libcurl4-gnutls-dev ntp

#create git directory
mkdir -p ./git

#clone librtlsdr source
cd ./git/
if [ ! -f "./librtlsdr" ]; then
	git clone https://github.com/steve-m/librtlsdr.git
fi

#build librtlsdr
cd ./librtlsdr/
mkdir -p ./build
cd ./build/
cmake -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON -DENABLE_ZEROCOPY=ON ../
make
sudo make install
sudo ldconfig
cd "$TOPDIR"

#clone rtlsdr-wsprd sources
cd ./git/
if [ ! -f "./rtlsdr-wsprd" ]; then
	git clone https://github.com/Guenael/rtlsdr-wsprd
fi

#build rtlsdr-wsprd
cd ./rtlsdr-wsprd/
make
sudo mkdir -p /usr/local/bin
sudo cp ./rtlsdr_wsprd /usr/local/bin/
#cd back to the top directory
cd "$TOPDIR"

#install udev rule for rtl
#sudo cp ./etc/udev/rules.d/90-rtl-sdr.rules /etc/udev/rules.d/

#install logrotate conf
sudo cp ./etc/logrotate.d/scan_wspr /etc/logrotate.d/

#create log directory
mkdir -p ./log

#install rc.local file
if [ ! -f /etc/rc.local.bak ]; then
	sudo mv /etc/rc.local /etc/rc.local.bak
fi
sudo cp ./etc/rc.local /etc/rc.local
