#!/bin/sh

#Install Oh my Zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

pwd=`pwd`

git clone https://github.com/k-a-u-s-h-i-k/settings.git ~/.settings
cd ~/.settings
git checkout coop

ln -s ~/.settings/.vimrc ~/.vimrc 
ln -s ~/.settings/.zshrc ~/.zshrc 
