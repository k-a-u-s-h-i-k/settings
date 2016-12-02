#!/bin/sh

#Install Oh my Zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

pwd=`pwd`

ln -s $pwd/.vimrc ~/.vimrc 
ln -s $pwd/.zshrc ~/.zshrc 
