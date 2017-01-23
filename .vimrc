syntax on "turn on syntax highlighting
set nocompatible "dont be compatible with vi
"tab settings
"set expandtab "expand tabs
set tabstop=4 "
set softtabstop=4
set shiftwidth=4

colorscheme zellner
set hlsearch " turn on search pattern highlighting
set ignorecase " ignore case when searching...
set smartcase "... unless pattern has uppercase character
set incsearch " enable incremental matches
"set list " display tabs and line endings
set lcs=trail:-,tab:-- " change the way tabs and line ends are displayed
set number "show line number in files
set backspace=2 "allow backspace to delete characters
set wildmenu "Enable enhanced command-line completion.
set hidden "allow multiple unsaved files to be open in the background
set showmode "show what mode we are in (insert, command, visual etc)
set autochdir "change the working directory to the directory in which the file being opened lives

"wrapping settings
"set wrap
"set linebreak
"set nolist
set textwidth=132 "max 132 characters in a line
"set fo+=t

filetype on "enable file specific behaviour
filetype plugin on "recognize what kind of file we are editing - c file, .h or makefile etc.
set tags=./tags; "locate tags file for ctags

call feedkeys(",ms") "simulate pressing ,ms on vim startup. This is my shortcut for highlighting marks

"au BufRead,BufNewFile *.logcat set filetype=logcat "recognize logcat files

"Settings for TagList plugin
"let Tlist_Use_Right_Window = 1
let Tlist_Auto_Open = 1
let Tlist_WinWidth = 50
let Tlist_Exit_OnlyWindow = 1

"show full path name of the file in the status bar
set statusline+=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"Always show the status line
set laststatus=2

"++++++++++++ MACROS +++++++++++++++++++++++++++++++++++++++++++++++
"Remove whitespaces at the end of the line
let @a=':%s/\s\+$//' "pressing @a in a file will remove all spaces at the end of a line

"load a cscope file. If the current dir doesn't have this file, the search keep going up until root dir is hit
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
	set csre "use cscope.out file location as the prefix to construct an absolute path
  endif
endfunction
if &diff
	colorscheme pablo "if vim is opened in diff mode (vimdiff), then use pablo colourscheme
else
	au BufEnter /* call LoadCscope()
endif

" Ctrl-P plugin setup
set runtimepath^=~/.vim/bundle/ctrlp.vim
if executable('ag')
  " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" Search for .ctrlp file if .svn, .git dir doesn't exist
let g:ctrlp_root_markers = ['.ctrlp']
" Default to file mode
let g:ctrlp_by_filename = 0
