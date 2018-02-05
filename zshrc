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
plugins=(git common-aliases svn-fast-info vi-mode z colored-man-pages)

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
alias mm='make'
alias mc='make clean'
alias mh='make hinstall'
alias mi='make install'
alias mru='make run'
alias mr='make report'
alias mrc='make clean && make report'
alias sc='screen -f -h 10000 -ln /dev/tty.SLAB_USBtoUART 115200'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias myvimrc='vim ~/.myvimrc'
alias myzshrc='vim ~/.myzshrc'
alias vi='vim'

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
    ACPI=$(command -v acpi)
    if [ -z "$ACPI" ]; then
        #return 1 if ACPI command does not exist
        return 1
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

#zsh vi keybindings
bindkey -v

#up arrow and down arrow use the commands previous history
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

#zsh spelling correction
setopt correct

#ZSH default editor
export EDITOR=`which vim`
export SVN_EDITOR=`which vim`
#set the right prompt in zsh to show laptop battery %
RPROMPT=$(battery_prompt)

if [ -e "$HOME/.myzshrc" ]; then
    source $HOME/.myzshrc
fi
