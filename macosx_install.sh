/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install findutils coreutils htop tig gawk git vim mongodb cowsay fortune
ln -s $HOME/linux-rcfiles/rcfile/bashrc $HOME/.bash_profile
ln -s $HOME/linux-rcfiles/rcfile/vimrc $HOME/.vimrc

# mongodb
sudo mkdir -p /data/db
sudo chown -R `id -un` /data/db

