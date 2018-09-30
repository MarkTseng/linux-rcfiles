/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install findutils coreutils htop tig gawk git vim mongodb
ln -s $HOME/linux-rcfiles/rcfile/bashrc $HOME/.bash_profile
ln -s $HOME/linux-rcfiles/rcfile/vimrc $HOME/.vimrc

# mongodb
mkdir -p /data/db
sudo chown -R `id -un` /data/db

