#!/bin/bash
sudo dpkg-reconfigure dash 
sudo apt-get install debian-builder exuberant-ctags cscope curl colordiff screen ncftp subversion git tig m4 bison g++ zlib1g-dev flex libncurses5-dev gperf iperf gawk autoconf texinfo libfreetype6-dev dos2unix build-essential vim-nox libstring-crc32-perl ccache libfreetype6 tcl8.5 unzip pkg-config git-core gnupg zip zlib1g-dev libc6-dev x11proto-core-dev libx11-dev python-markdown libxml2-utils tofrodos g++-multilib libgl1-mesa-dev lzma htop mr luarocks lua5.1 liblua5.1-0-dev git-svn spawn-fcgi libfcgi-dev libmysqlclient-dev samba cgdb apt-file python-setuptools python-fontforge sshfs rar unrar lib32z1-dev fortune-mod cowsay lynx-cur tftpd-hpa iotop vnc4server blackbox blackbox-themes menu proftpd-basic lsb-core openssh-server openssh-blacklist openssh-blacklist-extra pv python-sphinx texlive-latex-base cifs-utils crash sysstat manpages-posix-dev corkscrew smem cppcheck astyle cproto

# set samba 
sudo smbpasswd -a mark
#sudo vi /etc/samba/smb.conf
sudo rm -rf /etc/samba/smb.conf
sudo ln -s $HOME/linux-rcfiles/rcfile/smb.conf /etc/samba/smb.conf
sudo /etc/init.d/smbd restart

# subversion 1.6
#echo "http://us.archive.ubuntu.com/ubuntu precise main" >> /etc/apt/sources.list
#apt-get update
#apt-get -t precise install libsvn1 subversion. 

# install NFS
sudo apt-get install nfs-common nfs-kernel-server portmap
sudo chmod 777 /etc/exports
sudo echo "/home/mark   192.168.135.0/24(rw,sync,no_root_squash,no_subtree_check)" >>  /etc/exports
sudo chmod 644 /etc/exports

# remove rcfile
rm -rf $HOME/.bashrc

# link rcfile
ln -s $HOME/linux-rcfiles/rcfile/bashrc $HOME/.bashrc
ln -s $HOME/linux-rcfiles/rcfile/gdbinit $HOME/.gdbinit
ln -s $HOME/linux-rcfiles/rcfile/screenrc $HOME/.screenrc
ln -s $HOME/linux-rcfiles/rcfile/vimrc $HOME/.vimrc
ln -s $HOME/linux-rcfiles/mr/mrtrust $HOME/.mrtrust

# link nike mrconfig
mkdir $HOME/workshop

# install vimplugin
tar xfz vimplugin.tgz -C $HOME

# git ignore
ln -s $HOME/linux-rcfiles/rcfile/global_ignore $HOME/.global_ignore
ln -s $HOME/linux-rcfiles/rcfile/gitconfig $HOME/.gitconfig
ln -s $HOME/linux-rcfiles/rcfile/gitmessage.txt $HOME/.gitmessage.txt
git config --global core.excludesfile $HOME/.global_ignore
git config --global color.ui auto

# cgdb
mkdir $HOME/.cgdb
ln -s $HOME/linux-rcfiles/rcfile/cgdbrc $HOME/.cgdb/cgdbrc

# xterm-256color 
mkdir -p $HOME/.terminfo/x/ 
ln -s $HOME/linux-rcfiles/rcfile/xterm-256color $HOME/.terminfo/x/xterm-256color

# powerline install
cd $HOME/linux-rcfiles/powerline
./setup.py build
sudo ./setup.py install

# powerline shell install
#cd $HOME/linux-rcfiles/powerline-shell
#./install.py
#ln -s $HOME/linux-rcfiles/powerline-shell/powerline-shell.py $HOME/powerline-shell.py

# vnc4server
vnc4server
vnc4server -kill :1
rm -rf $HOME/.vnc/xstartup
ln -s $HOME/linux-rcfiles/rcfile/xstartup $HOME/.vnc/xstartup

# tftp
sudo mkdir $HOME/tftp
sudo chmod 777 $HOME/tftp
sudo ln -s $HOME/tftp /tftp
sudo rm -rf /etc/default/tftpd-hpa
sudo cp $HOME/linux-rcfiles/rcfile/tftpd-hpa /etc/default/tftpd-hpa

# setup /etc/init.d script
sudo cp -a $HOME/linux-rcfiles/rcS/*.sh /etc/init.d
sudo update-rc.d mount-ts451.sh defaults

# ccache 
sudo mkdir /ccache_pool
sudo chmod 777 /ccache_pool

# python auto complete
ln -s $HOME/linux-rcfiles/rcfile/pythonstartup.py $HOME/.pythonstartup.py

# ssh hosts config
ln -s $HOME/linux-rcfiles/rcfile/ssh_config $HOME/.ssh/config 
# SSH Proxy
echo "#   ProxyCommand /usr/bin/corkscrew 192.168.0.101 1080 %h %p" >> /etc/ssh/ssh_config

# wake on lang setting
sudo ethtool -s enp3s0 wol g
