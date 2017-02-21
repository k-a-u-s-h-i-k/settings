export ZSH=$HOME/.oh-my-zsh # Path to your oh-my-zsh installation.

ZSH_THEME="powerlevel9k/powerlevel9k" #current theme
ZSH_THEME="agnoster" #current theme
COMPLETION_WAITING_DOTS="true" #enable red dots during cmpletion
plugins=(git common-aliases svn-fast-info)

source $ZSH/oh-my-zsh.sh

#---------------------  ALIAS ------------------------------
alias cls=clear
alias ll='ls -l'
alias la='ls -a'
alias mc='make clean'
alias mh='make hinstall'
alias mi='make install'
alias mr='make run'
alias mre='make report'
alias mcr='make clean && make report'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias qemu_64='qemu-system-x86_64 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias qemu='qemu-system-i386 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias vim=/usr/local/Cellar/vim/8.0.0002/bin/vim
alias vi=/usr/local/Cellar/vim/8.0.0002/bin/vim
alias pi='ssh osmc@192.168.1.109'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
#alias -g grep='grep -I'
#---------------------  ALIAS ------------------------------

source $ZSH/custom/personal/personal.sh

#---------------------  ZSH OPTIONS ------------------------------
export KEYTIMEOUT=1 #reduce esc key timeout in vim mode to 0.1 seconds
bindkey -v #zsh vi keybindings
bindkey '^[OA' up-line-or-beginning-search #up arrow use the commands previous history
bindkey '^[OB' down-line-or-beginning-search #down arrrow use the commands previous history
bindkey "^I" expand-or-complete-with-dots #insert red dots when waiting for completion
setopt HIST_FIND_NO_DUPS #when searching/scrolling through history, ignore dupe entries
setopt correct #zsh spelling correction
#---------------------  ZSH OPTIONS ------------------------------

#Increase the number of open file descriptors.
#This is needed while building android
ulimit -S -n 1024
export SVN_EDITOR=vim
export CCACHE_DIR=$HOME/Work/ccache
export USE_CCACHE=1

function go {
	if [ "x$1" = "x" ]; then
		echo "Directories:"
		for i in ~/.go-dirs/*
		do
			printf "%20s %s\n" `basename $i` `cat $i`
		done
	else
		cd `cat ~/.go-dirs/$1`
	fi
}

function pgo {
	if [ "x$1" = "x" ]; then
		echo "Missing argument"
	else
		pushd `cat ~/.go-dirs/$1`
	fi
}

function save {
	if [ "x$1" = "x" ]; then
		echo "Missing argument"
	else
		pwd > ~/.go-dirs/$1
	fi
}

function unsave {
	rm -v ~/.go-dirs/$1
}

#export PIP_REQUIRE_VIRTUALENV=true # pip should only run if there is a virtualenv currently activated 
export PIP_DOWNLOAD_CACHE=${HOME}/.pip/cache # cache pip-installed packages to avoid re-downloading
export EDITOR=/usr/local/Cellar/vim/8.0.0002/bin/vim #ZSH default editor

#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------
# zsh theme powerlevel9k requires this so the prompt doesn't show username@machine 
export DEFAULT_USER=$USER
POWERLEVEL9K_TIME_FOREGROUND='black'
POWERLEVEL9K_TIME_BACKGROUND='202'
#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------

# Avoid homebrew from collecting analytics info
export HOMEBREW_NO_ANALYTICS=1

# ZSH Syntax Highlighting  - note this should be the last entry
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
