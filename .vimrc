set nocompatible "Forget being compatible with good ol' vi
syntax on "turn on syntax highlighting

"set expandtab "expand tabs
set tabstop=4 "number of spaces that a <tab> in the file counts for
set softtabstop=4 "number of spaces that a <tab> counts for while performing editing operations
set shiftwidth=4
set autoindent "automatically align to indentation for a new line

colorscheme badwolf "choose default colourscheme
set hlsearch " turn on search pattern highlighting
set ignorecase " ignore case when searching...
set smartcase " ... unless pattern has uppercase character
set incsearch " enable incremental matches
"set list " display tabs and line endings
set listchars=trail:-,tab:-- " change the way tabs and line ends are displayed
set number "show line number in files
set backspace=2 "allow backspace to delete characters
set hidden "allow multiple files to opened in different buffers, 'hidden' in the background
set wildmenu "an extra bar pops up in ex (command) mode that shows completion options
set lazyredraw "no screen redraw while executing macros, registers and other commands that haven't been typed
set autochdir "change the working directory to the directory in which the file being opened lives
set cursorline "highlight current line
set cinoptions=:0,b1: "align switch case and break on switch statement
set textwidth=132 "max 132 characters in a line

"disable arrow keys in normal mode (use hjkl instead)
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

"if our '{' or '}' are not in the first column for a function, use find
map [[ ?{<CR>w99[{:nohl<CR>
map ][ /}<CR>b99]}:nohl<CR>
map ]] j0[[%/{<CR>:nohl<CR>
map [] k$][%?}<CR>:nohl<CR>

filetype on "turn on file type recognition to do custom stuff
filetype plugin on "recognize what kind of file we are editing - c file, .h or makefile etc.
"filetype indent on "turn on indentation settings for specific file types TODO Set this up
set tags=./tags; "locate tags file for ctags

"Settings for TagList plugin
"let Tlist_Use_Right_Window = 1
"let Tlist_Auto_Open = 1
"let Tlist_WinWidth = 50
"let Tlist_Exit_OnlyWindow = 1

"------------------------------  MACROS ----------------------------------
"Remove whitespaces at the end of the line
let @a=':%s/\s\+$//' "pressing @a in a file will remove all spaces at the end of a line (typing ctrl + v followed by enter gives ^M)

"------------------------- LEADER KEY SHORTCUTS --------------------------
let mapleader = "\<Space>"
"leader + w to save a file
nnoremap <Leader>w :w<CR>
"various shortcuts to copy/paste from system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>


"--------------------- Vim-Plug managed plugins ------------------------------
"If vim-plug isn't installed, install it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
	"plugin installed, load plugins
	call plug#begin('~/.vim/plugged')
		" ariline plugin
		Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'

		"Buffers in status line
		Plug 'bling/vim-bufferline'

		"Plugins to support snips
		Plug 'MarcWeber/vim-addon-mw-utils'
		Plug 'tomtom/tlib_vim'
		Plug 'garbas/vim-snipmate'
		Plug 'honza/vim-snippets'
	call plug#end()
endif

"------------------------------ Functions ------------------------------------

"load a cscope file. If the current dir doesn't have this file, the search keeps going up until root dir is hit
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

function! SvnCheckIfNewFile()
	"let filename = expand('%:t')
	execute "! svn status -q | grep " . expand('%:t')
	echo out
endfunction

" Removes trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

" Open quickfix window list after search completes
function! MySearch()
  let grep_term = input("Enter search term: ")
  if !empty(grep_term)
    execute 'silent grep' grep_term | copen
  else
    echo "Empty search term"
  endif
  redraw!
endfunction

" :Grep in vim calls ag and automatically opens the quickfix window list
command! Grep call MySearch()

if &diff
    colorscheme blue "if vim is opened in diff mode (vimdiff), then use pablo colourscheme
else
    au BufEnter /* call LoadCscope()
endif

" Ctrl-P plugin setup
"set runtimepath^=~/.vim/bundle/ctrlp.vim
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

let c_space_errors = 1 "highlight trailing white space for c files
