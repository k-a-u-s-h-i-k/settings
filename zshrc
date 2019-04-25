export ZSH=$HOME/.oh-my-zsh # Path to your oh-my-zsh installation.

ZSH_THEME="spaceship" #current theme
SPACESHIP_BATTERY_SHOW=always
SPACESHIP_GIT_STATUS_SHOW=false
COMPLETION_WAITING_DOTS="true" #enable red dots during cmpletion
plugins=(git common-aliases svn-fast-info vi-mode globalias z colored-man-pages fancy-ctrl-z zsh-autosuggestions alias-tips notify)
source $ZSH/oh-my-zsh.sh

#---------------------  ALIAS ------------------------------
alias cls=clear
alias ll='ls -l'
alias la='ls -a'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias qemu_64='qemu-system-x86_64 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias qemu='qemu-system-i386 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias zshrc='e ~/.zshrc'
alias vimrc='e ~/.vimrc'
alias i3c='e ${HOME}/.settings/i3/config'
alias vpn='/opt/cisco/anyconnect/bin/vpnui'
alias per='e ${HOME}/.oh-my-zsh/custom/personal/personal.sh'
alias muttrc='e ${HOME}/.mutt/muttrc'
alias o='xdg-open'
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
HISTSIZE=10000000 #number of commands from history file loaded into the shell’s memory
SAVEHIST=10000000 #number of commands the history file can hold
setopt HIST_FIND_NO_DUPS #when searching/scrolling through history, ignore dupe entries
setopt HIST_SAVE_NO_DUPS #Don't write duplicate entries in the history file.
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

#zsh completion for go commands
function go_completion {
    #for each link in MARKPATH
    for link ($MARKPATH/*(N@)) {
            #add to completion
	          compadd ${link:t}
    }
}

#call go_completion for go auto completion
compdef go_completion go

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

#patchrb <review id>
function patchrb()
{
	go hyp
	gcm
	git checkout -b $1
	rbt patch --print $1 > /tmp/$1.patch
	patch -p0 -i /tmp/$1.patch
}

#open file in an existing instance of emacs if it exists or create a new frame otherwise
function e()
{
	WINDOWS=$(xdotool search --all --onlyvisible emacs 2> /dev/null)
	if [ ! -z $WINDOWS ]; then
		# an existing frame of emacs already exists
		if [ "$#" -ne 0 ]; then
			# user has supplied a file to open
			emacsclient -n $@
		else
			# just focus the emacs window if a file hasn't been supplied
			i3-msg '[class="Emacs"] focus' > /dev/null 2>&1
			return
		fi
	else
		# crete a new frame and open the file
		emacsclient -nc $@
	fi
}

function disp()
{
    if [ "$1" = "m" ]; then
        # enable main display
        xrandr > /dev/null
        sleep 1 # give some time for display port monitor to wake up
        xrandr --output DP2-2 --auto --output eDP1 --off
    else
        # enable laptop screen
        xrandr --output DP2-2 --off --output eDP1 --auto
    fi
}

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

# ZSH Syntax Highlighting note this should be the last entry
if [ -e $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
