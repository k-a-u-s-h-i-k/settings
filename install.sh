#!/bin/sh

pwd=`pwd`
git_prog=`command -v git`

if [ -n "${git_prog}" ]; then
	#clone my repo
	git clone https://github.com/k-a-u-s-h-i-k/settings.git ~/.settings
	cd ~/.settings

	#switch to the coop branch
	git checkout coop
else
	echo "Git not installed on the system. Installing now..." 
	sudo apt-get install git -y
fi

#Install Oh my Zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#setup softlinks
ln -s ~/.settings/.vimrc ~/.vimrc 
ln -s ~/.settings/.zshrc ~/.zshrc 
