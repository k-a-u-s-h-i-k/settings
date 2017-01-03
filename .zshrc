# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="pure"

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
# COMPLETION_WAITING_DOTS="true"

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
plugins=(git common-aliases svn-fast-info)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

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

############################ MY PERSONAL ADDONS #####################################

export SVN_EDITOR=vim
alias cls=clear
alias ll='ls -l'
alias la='ls -a'
alias mc='make clean'
alias mh='make hinstall'
alias mi='make install'
alias mr='make run'
alias mre='make report'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias qemu_64='qemu-system-x86_64 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias qemu='qemu-system-i386 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias vim=/usr/local/Cellar/vim/8.0.0002/bin/vim
alias vi=/usr/local/Cellar/vim/8.0.0002/bin/vim
alias pi='ssh osmc@192.168.1.109'
#alias -g grep='grep -I'

source $ZSH/custom/personal/personal.sh

#Increase the number of open file descriptors.
#This is needed while building android
ulimit -S -n 1024

export CCACHE_DIR=$HOME/Work/ccache
export USE_CCACHE=1

#set the name of a tab
function nw {
    echo -n -e "\033]0;$1\007"
}

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

# pip should only run if there is a virtualenv currently activated 
#export PIP_REQUIRE_VIRTUALENV=true 
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=${HOME}/.pip/cache

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

#zsh vi keybindings
bindkey -v

#reduce esc key timeout in vim mode to 0.1 seconds
export KEYTIMEOUT=1

#up arrow and down arrow use the commands previous history
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

#zsh spelling correction
setopt correct

#ZSH default editor
export EDITOR=/usr/local/Cellar/vim/8.0.0002/bin/vim

#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------
# zsh theme powerlevel9k requires this so the prompt doesn't show username@machine 
export DEFAULT_USER=$USER
POWERLEVEL9K_TIME_FOREGROUND='black'
POWERLEVEL9K_TIME_BACKGROUND='202'
#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------

# Avoid homebrew from collecting analytics info
export HOMEBREW_NO_ANALYTICS=1

# ZSH Syntax Highlighting
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

####################################################################################
