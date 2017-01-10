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
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O oh.sh
sed -i '/env zsh/d' oh.sh
sed -i '/chsh -s/d' oh.sh
chmod +x oh.sh
./oh.sh

#setup softlinks
echo ""
echo "=============== Setup Soft Links ================="
ln -s ~/.settings/.vimrc ~/.vimrc 
mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
ln -s ~/.settings/.zshrc ~/.zshrc 
echo "=============== Soft links setup done ================="


echo "=============== Setup cscope maps ====================="
if [ ! -d ~/.vim ]; then
	mkdir ~/.vim #if ~/.vim dir doesn't exist, create it
fi
if [ ! -d ~/.vim/plugin ]; then
	mkdir ~/.vim/plugin #if plugin dir doesn't exist, create it
fi
cd ~/.vim/plugin
wget http://cscope.sourceforge.net/cscope_maps.vim
cd - # go back to the previous directory

echo "=============== Your vimrc and zshrc files are now in your home folder ================="
echo "=============== Setup successful =================="

