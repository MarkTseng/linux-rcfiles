#!/bin/bash
# install path
AUTOSTART_DIR=$HOME/.config/autostsrt
UDEV_HWDB_DIR=/etc/udev/hwdb.d
GRUB_DIR=/etc/default
# install xrandr & input
mkdir $AUTOSTART_DIR
cp autostart/* $AUTOSTART_DIR

# install udev hwdb
sudo cp -a udev $UDEV_HWDB_DIR
sudo systemd-hwdb update

# grub
apt install ttf-unifont -y
sudo grub-mkfont -s 32 -o /boot/grub/fonts/unicode32.pf2 /usr/share/fonts/truetype/unifont/unifont.ttf
sudo cp -a grub/grub $GRUB_DIR
sudo update-grub

# fbtermrc
cp -a fbtermrc $HOME/.fbtermrc
sudo setcap 'cap_sys_tty_config+ep' /usr/bin/fbterm

# wifi power saving
sudo cp default-wifi-powersave-on.conf /etc/NetworkManager/conf.d/

# suspend
sudo echo "HandleLidSwitchExternalPower=ignore" >> /etc/systemd/logind.conf
sudo systemctl restart systemd-logind

