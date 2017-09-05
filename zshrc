# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="spaceship"

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
plugins=(git common-aliases svn-fast-info vi-mode globalias)

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

#---------------------  CUSTOM OPTIONS ------------------------------
export SVN_EDITOR=vim
alias cls=clear
alias ll='ls -l'
alias la='ls -a'
alias mm='make'
alias mc='make clean'
alias mh='make hinstall'
alias mi='make install'
alias mru='make run'
alias mr='make report'
alias mrc='make clean && make report'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias qemu_64='qemu-system-x86_64 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias qemu='qemu-system-i386 -m 2G -kernel image.ifs -display none -serial stdio -serial tcp::5678,ipv4,server,nowait,nodelay -gdb tcp::6789,ipv4,server,nowait,nodelay -smp 1'
alias vimrc='vim ~/.myvimrc'
alias zshrc='vim ~/.myzshrc'

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
	if [ $1 -z ]; then
		#no arguments given
		hash -d
	else
		~$1
	fi
}

function save {
	if [ $1 -z ]; then
		#no arguments given
		echo "ERROR: Missing argument\n"
		echo "usage:"
		echo "save <name_of_bookmark>"
	else
		ln -s $PWD $MARKPATH/$1
		hash -d -- $1=$PWD
	fi
}

function unsave {
	rm -Ivf ~/.go-dirs/$1
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

#zsh vi keybindings
bindkey -v

#up arrow and down arrow use the commands previous history
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

#zsh spelling correction
setopt correct

#ZSH default editor
export EDITOR=`which vim`

#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------
# zsh theme powerlevel9k requires this so the prompt doesn't show username@machine
export DEFAULT_USER=$USER
POWERLEVEL9K_TIME_FOREGROUND='black'
POWERLEVEL9K_TIME_BACKGROUND='202'
#---------------------  POWERLEVEL9K THEME OPTIONS ------------------------------

source $HOME/.myzshrc
