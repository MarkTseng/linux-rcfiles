#!/bin/bash
wget -O apple-logo.zip http://drive.noobslab.com/data/themes/mac/apple-logo.zip
sudo unzip apple-logo.zip -d /usr/share/unity/5/

sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install mac-os-lion-icons-v2
sudo apt-get install mac-os-lion-theme-v2

wget -O mac-cursors.zip http://drive.noobslab.com/data/themes/mac/mac-cursors.zip
sudo unzip mac-cursors.zip -d /usr/share/icons/; rm mac-cursors.zip
cd /usr/share/icons/mac-cursors
sudo chmod +x install-mac-cursors.sh uninstall-mac-cursors.sh
sudo ./install-mac-cursors.sh

