#!/bin/sh

pwd=`pwd`
git_prog=`command -v git`

if [ -z "${git_prog}"]; then
	echo "Git not installed on the system. Installing now..." 
	sudo apt-get install git -y
fi

#clone my repo
echo =============== Cloning Kaushiks repo ================="
git clone https://github.com/k-a-u-s-h-i-k/settings.git ~/.settings
cd ~/.settings

#switch to the coop branch
git checkout coop

#Install Oh my Zsh
echo =============== Installing OH MY ZSH ================="
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#setup softlinks
ln -s ~/.settings/.vimrc ~/.vimrc 
ln -s ~/.settings/.zshrc ~/.zshrc 
