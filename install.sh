#!/bin/sh

pwd=`pwd`
git_prog=`command -v git`
zsh_prog=`command -v zsh`

if [ -z "${git_prog}" ]; then
	echo ""
	echo "Git not installed on the system. Installing now..." 
	sudo apt-get install git -y
fi

#clone my repo
echo ""
echo "=============== Cloning Kaushik's repo ================="
git clone https://github.com/k-a-u-s-h-i-k/settings.git ~/.settings
cd ~/.settings

#switch to the coop branch
git checkout coop

#install zsh if not installed
if [ -z "${zsh_prog}" ]; then
	echo ""
	echo "=============== Installing ZSH ================="
	sudo apt-get install zsh -y
fi

#Install Oh my Zsh
echo ""
echo "=============== Installing OH MY ZSH ================="
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -); exit"

#setup softlinks
echo ""
echo "=============== Setup Soft Links ================="
ln -s ~/.settings/.vimrc ~/.vimrc 
mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
ln -s ~/.settings/.zshrc ~/.zshrc 

