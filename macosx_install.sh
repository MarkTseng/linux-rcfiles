/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install findutils coreutils htop tig gawk git vim cowsay fortune
ln -s $HOME/linux-rcfiles/rcfile/bashrc $HOME/.bash_profile
ln -s $HOME/linux-rcfiles/rcfile/vimrc $HOME/.vimrc
tar xfz vimplug.tar -C $HOME/

# mongodb
brew tap mongodb/brew
brew install mongodb-community
brew install mongodb-community-shell
sudo mkdir -p /data/db
sudo chown -R `id -un` /data/db
brew services start mongodb-community
