set nocompatible "Forget being compatible with good ol' vi
syntax on "turn on syntax highlighting

"tab settings
"set expandtab "expand tabs to spaces
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
set wildmenu "Enable enhanced command-line completion
set lazyredraw "no screen redraw while executing macros, registers and other commands that haven't been typed
set autochdir "change the working directory to the directory in which the file being opened lives
set cursorline "highlight current line
set cinoptions=:0,b1: "align switch case and break on switch statement
set history=1000 "remember 1000 commands/search strings
set sessionoptions-=options "when a session is saved, do not store vimrc options
set autoread "reread file if an external program has changed a file
autocmd Filetype c setlocal textwidth=132  "max 132 characters in a line for c files

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

filetype on "enable file specific behaviour
filetype plugin on "recognize what kind of file we are editing - c file, .h or makefile etc.
"filetype indent on "turn on indentation settings for specific file types TODO Set this up
set tags=./tags; "locate tags file for ctags

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
"leader + m to run make on the terminal
noremap <Leader>m :!make <enter>
"leader + c to run make clean on the terminal
noremap <Leader>c :!make clean <enter>
"leader + r to run make report on the terminal
noremap <Leader>r :!make report <enter>
"leader + n to run make clean && make report on the terminal
noremap <Leader>n :!make clean && make report <enter>
"save current session
noremap <silent> <Leader>s :mksession <enter>

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

		"Git plugins
		Plug 'airblade/vim-gitgutter'
		Plug 'tpope/vim-fugitive'
		Plug 'gregsexton/gitv', {'on': ['Gitv']}
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

" Highlight these keywords
function! s:Keywords()
   syn keyword cConstant EOK
   syn keyword cConstant UT_FAIL UT_PASS
endfunction
autocmd FileType c,cpp call s:Keywords()

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

"---------------------------------------- CUSTOM ----------------------------------------
if &diff
    colorscheme blue "if vim is opened in diff mode (vimdiff), then use pablo colourscheme
else
    au BufEnter /* call LoadCscope()
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
" Use % key to jump between if,else if and else statements
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if executable('ag')
  " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let c_space_errors = 1 "highlight trailing white space for c files

" Automatically reload vimrc when a write to it is detected
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

