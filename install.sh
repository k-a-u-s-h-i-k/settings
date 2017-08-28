#!/bin/sh

pwd=`pwd`
git_prog=`command -v git`
zsh_prog=`command -v zsh`

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

output()
{
	echo ""
	printf "${GREEN}"
	echo $1
	printf "${NORMAL}"
}

if [ -z "${git_prog}" ]; then
    output "============== Installing Git =========================="
	sudo apt-get install git -y
fi

output "============== Installing Ag =========================="
sudo apt install -y silversearcher-ag

#clone my repo
output "=============== Cloning Kaushik's repo ================="
git clone https://github.com/k-a-u-s-h-i-k/settings.git ~/.settings
cd ~/.settings

#switch to the coop branch
git checkout coop

#install zsh if not installed
if [ -z "${zsh_prog}" ]; then
	output "=============== Installing ZSH ================="
	sudo apt-get install zsh -y
fi

#Install Oh my Zsh
output "=============== Installing OH MY ZSH ================="
wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O oh.sh
sed -i '/env zsh/d' oh.sh
sed -i '/chsh -s/d' oh.sh
chmod +x oh.sh
./oh.sh
rm -f ./oh.sh

#setup softlinks
output "=============== Setup Soft Links ================="
ln -s ~/.settings/.vimrc ~/.vimrc
echo "\"Add your custom vim settings to this file" > ~/.myvimrc
echo "#Add your custom zsh settings to this file" > ~/.myzshrc
mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
ln -s ~/.settings/.zshrc ~/.zshrc
output "=============== Soft links setup done ================="


output "=============== Setup cscope maps ====================="
if [ ! -d ~/.vim ]; then
	mkdir ~/.vim #if ~/.vim dir doesn't exist, create it
fi
if [ ! -d ~/.vim/plugin ]; then
	mkdir ~/.vim/plugin #if plugin dir doesn't exist, create it
fi
cd ~/.vim/plugin
wget http://cscope.sourceforge.net/cscope_maps.vim
cd - # go back to the previous directory

output "=============== Download badwolf theme ====================="
if [ ! -d ${HOME}/.vim/colors ]; then
    mkdir ${HOME}/.vim/colors
fi
cd ${HOME}/.vim/colors
wget https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim
cd -

output "=============== Setup Makefile ftplugin ==============="
if [ ! -d ~/.vim/ftplugin ]; then
	mkdir ~/.vim/ftplugin
fi
cd ~/.vim/ftplugin
#do not expand tabs in a makefile
echo "set noexpandtab" > make.vim
cd -

output "=============== Install vim-gtk to get global clipboard support ==============="
sudo apt install vim-gtk -y

output "=============== Setup Go directories ==============="
if [ ! -d ~/.go-dirs ]; then
    mkdir ~/.go-dirs
fi

#open vim once to install Plug
vim +qall
#open vim now to install all plugins
vim "+PlugInstall --sync" +qall

output "=============== vimrc and zshrc files are now in your home folder ================="
output "=============== Add custom vim settings to .myvimrc and zsh settings to .myzshrc files ============"
output "=============== Setup successful =================="

#Check this site for how to setup cron task for auto git pull
#https://thoughtsimproved.wordpress.com/2015/08/17/self-updating-git-repos/