# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME=powerlevel10k/powerlevel10k

# always show laptop battery percentage
if [ ${ZSH_THEME} = "spaceship" ]; then
    SPACESHIP_GIT_STATUS_SHOW=false 
    SPACESHIP_BATTERY_SHOW=always
fi
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git common-aliases svn-fast-info vi-mode z colored-man-pages fancy-ctrl-z zsh-autosuggestions alias-tips globalias)
if [ ! -z ${INSIDE_EMACS+x} ]; then
    plugins=(git common-aliases svn-fast-info alias-tips notify)
fi

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

if [ -e "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

#---------------------  CUSTOM OPTIONS ------------------------------
alias cls=clear
alias ll='ls -l'
alias la='ls -a'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias myvimrc='vim ~/.myvimrc'
alias myzshrc='vim ~/.myzshrc'
alias vi='vim'
alias o='xdg-open'
alias grbh='git rebase -i $(git merge-base master HEAD)'

function gs {
    # (1) git rev-list master...HEAD gives a list of all commits starting at a common ancestor of both commits and HEAD
    # (2) From (1), we pick the 2nd oldest commit so the commit message from this can be used
    # (3) reset is used to take the branch back to (2)
    # (4) At (3), commit these changes using the same commit message as (2)

    # make sure we are in a git repo
    if [ ! $(git rev-parse --git-dir 2> /dev/null) ]; then
        echo "Cannot run this outside a git repo"
        return 127
    fi

    # make sure we are not in master
    branch=$(git branch --show-current)
    if [ ${branch} = "master" ]; then
        echo "Do not run this command on master. Switch to your feature branch first"
        return 127
    fi

    echo "Squashing commits..."
    git reset --soft $(git rev-list master...HEAD | tail -n 1) > /dev/null 2>&1 && git commit --all --amend --no-edit > /dev/null 2>&1
    echo "Completed"
}

# usage:
# Go to a folder to save as a bookmark
# save <name of bookmark>
#
# To go to this direcoty from any other directory
# go <name of bookmark>
# or
# ~<name of bookmark>
#
# To delete a bookmark
# unsave <name of bookmark>
#
# ex.
# cd /tmp
# save tmp
# cd ~
# go tmp
# unsave tmp
#
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

# a simple hex/dec/bin to bin/dec/hex convertor
function = ()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        cat << HERE
Invalid Syntax

Examples:

Binary to Hex
    = 2to10 1011

Binary to Decimal
    = 2to10 1011

Decimal to Binary
    = 10to2 3735929054

Decimal to Hex
    = 10to16 11011110101011011100000011011110

Hex to Binary
    = 16to2 1000

Hex to Decimal
    = 16to10 1000
HERE
        return 1
    fi

    if [ $1 = "2to10" ]; then
        typeset -i10 answer="2#$2"
    elif [ $1 = "2to16" ]; then
        typeset -i16 answer="2#$2"
    elif [ $1 = "16to2" ]; then
        typeset -i2 answer="16#$2"
    elif [ $1 = "16to10" ]; then
        typeset -i10 answer="16#$2"
    elif [ $1 = "10to2" ]; then
        typeset -i2 answer="$2"
    elif [ $1 = "10to16" ]; then
        typeset -i16 answer="$2"
    fi

    # strip 16# or 2# in front of those bases and then print
    echo ${answer#*#}
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

# usage
#     present #will turn on HDMI1 if connected and kill xautolock
#     present off #will turn off HDMI1 and start xautolock
function present()
{
    if [ "$1" = "off" ]; then
        # turn off HDMI1 display
        xrandr --output HMDI1 --off
        # lock screen after 5 minutes
        xautolock -time 5 -locker 'i3lock -c 000000'
    else
        #check if HDMI1 is connected
        xrandr | grep -q "HDMI1 connected [0-9]"
        if [ $? -ne 0 ]; then
            echo "HDMI display port is not connected to a screen. Please connect and try again."
            return 1
        fi

        # turn on HDMI1 display
        xrandr --output HMDI1 --auto

        # turn off auto lock screen
        pkill xautolock
    fi
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

#zsh vi keybindings
bindkey -v

#up arrow and down arrow use the commands previous history
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#zsh spelling correction
setopt correct

#ZSH default editor
export EDITOR=`which vim`
# If emacs isn't started while starting emacsclient, this will auto start
export ALTERNATE_EDITOR=""  
export SVN_EDITOR=`which vim`
#enable 256 colour support
export TERM=xterm-256color

if [ -e "$HOME/.myzshrc" ]; then
    source $HOME/.myzshrc
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
