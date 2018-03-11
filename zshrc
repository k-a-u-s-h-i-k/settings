export ZSH=$HOME/.oh-my-zsh # Path to your oh-my-zsh installation.

ZSH_THEME="spaceship" #current theme
COMPLETION_WAITING_DOTS="true" #enable red dots during cmpletion
plugins=(git common-aliases svn-fast-info vi-mode globalias z colored-man-pages)

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
alias pi='ssh osmc@192.168.1.109'
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias i3c='vim ${HOME}/.settings/i3/config'
alias vpn='/opt/cisco/anyconnect/bin/vpnui'
alias per='vim ${HOME}/.oh-my-zsh/custom/personal/personal.sh'
alias muttrc='vim ${HOME}/.mutt/muttrc'
#alias -g grep='grep -I'
#---------------------  ALIAS ------------------------------

if [ -e ${ZSH}/custom/personal/personal.sh ]; then
	source $ZSH/custom/personal/personal.sh
fi

#---------------------  ZSH OPTIONS ------------------------------
export KEYTIMEOUT=1 #reduce esc key timeout in vim mode to 0.1 seconds
bindkey -v #zsh vi keybindings
bindkey '^[OA' up-line-or-beginning-search #up arrow use the commands previous history
bindkey '^[OB' down-line-or-beginning-search #down arrrow use the commands previous history
bindkey "^I" expand-or-complete-with-dots #insert red dots when waiting for completion
setopt HIST_FIND_NO_DUPS #when searching/scrolling through history, ignore dupe entries
setopt correct #zsh spelling correction
setopt extended_glob
#---------------------  ZSH OPTIONS ------------------------------

#Increase the number of open file descriptors.
#This is needed while building android
ulimit -S -n 1024
export SVN_EDITOR=vim
export CCACHE_DIR=$HOME/Work/ccache
export USE_CCACHE=1

export MARKPATH=$HOME/.go-dirs

# Populate the hash for dir bookmarks
for link ($MARKPATH/*(N@)) {
	hash -d -- ${link:t}=${link:A}
}

function go {
	if [ -z "$1" ]; then
		#no arguments given
		hash -d
	else
		~$1
	fi
}

function save {
	if [ -z "$1" ]; then
		#no arguments given
		echo "ERROR: Missing argument\n"
		echo "usage:"
		echo "save <name_of_bookmark>"
	else
        if [ -h "$MARKPATH/$1" ]; then
            #if soft link exists, delete before creating new soft link with the same name
            rm -rf $MARKPATH/$1
        fi
		ln -s $PWD $MARKPATH/$1
		hash -d -- $1=$PWD
	fi
}

function unsave {
	if [ -z "$1" ]; then
		#no arguments given
		echo "ERROR: Missing argument\n"
		echo "usage:"
		echo "unsave <name_of_bookmark>"
	else
        #if bookmark exists in hash table, then remove
        if [ -h "$MARKPATH/$1" ]; then
            rm -If ~/.go-dirs/$1
            unhash -d $1
        fi
	fi
}

# Function for always using one (and only one) vim server
# If you really want a new vim session, simply do not pass any argument to this function.
function v {
	vim_orig=$(which 2>/dev/null vim)
	if [ -z $vim_orig ]; then
		echo "$SHELL: vim: command not found"
		return 127;
	fi
	$vim_orig --serverlist | grep -q VIM
	# If there is already a vimserver, use it
	# unless no args were given
	if [ $? -eq 0 ]; then
		if [ $# -eq 0 ]; then
			$vim_orig
		else
			$vim_orig --remote "$@"
		fi
	else
		$vim_orig --servername vim "$@"
	fi
}

function battery_prompt()
{
	#if acpi utility does not exist, do not show battery in zsh shell
	ACPI=$(command -v acpi)
	if [ -z ACPI ]; then
		return 1;
	fi
	charging=$(acpi 2>/dev/null | grep -c '^Battery.*Discharging')
	if [[ $charging -gt 0 ]]; then
		battery=$(acpi 2>/dev/null | cut -f2 -d ',' | tr -cd '[:digit:]')
		if [ $battery -gt 50 ] ; then
			color='green'
		elif [ $battery -gt 20 ] ; then
			color='yellow'
		elif [ $battery -gt 10 ] ; then
			color='red'
		else
			color='red'
			echo -n "%{$fg_bold[$color]%}BATTERY TOO LOW. CHARGE BATTERY ASAP! "
		fi

		echo -n "%{$fg_bold[$color]%}[$battery%%]%{$reset_color%}"
	fi
}

#patchrb <review id>
function patchrb()
{
	go hyp
	gcm
	git checkout -b $1
	rbt patch --print $1 > /tmp/$1.patch
	patch -p0 -i /tmp/$1.patch
}

#open emacs client in the background
function e()
{
  emacsclient -c $1 &
}

#check if emacs is available on the system
emacs=$(command -v emacs)
if [ ! -z $emacs ]; then
	emacs=$(pgrep emacs)
	#start emacs in daemon mode if not already started
	if [ -z $emacs ]; then
		emacs --daemon > /dev/null 2>&1 &
	fi
fi

# Set background wallpaper only the first time
if [ ! -e /tmp/wallpaper ]; then
    touch /tmp/wallpaper
    if [ -d ${HOME}/Pictures/wallpapers ]; then
        feh --randomize --bg-fill ${HOME}/Pictures/wallpapers/*
    fi
fi

#export PIP_REQUIRE_VIRTUALENV=true # pip should only run if there is a virtualenv currently activated
export PIP_DOWNLOAD_CACHE=${HOME}/.pip/cache # cache pip-installed packages to avoid re-downloading
export EDITOR=`which vim` #ZSH default editor
# If emacs isn't started while starting emacsclient, this will auto start
export ALTERNATE_EDITOR=""
export TERM=xterm-256color

#set the right prompt in zsh to show laptop battery %
RPROMPT=$(battery_prompt)

# ZSH Syntax Highlighting note this should be the last entry
if [ -e $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
