set nocompatible "Forget being compatible with good ol' vi
syntax on "turn on syntax highlighting

"tab settings
set expandtab "expand tabs to spaces
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
set mouse=a "Add mouse support to vim
autocmd Filetype c setlocal textwidth=132  "max 132 characters in a line for c files

"set default shell within vim to zsh
if !empty(glob('/usr/bin/zsh'))
    set shell=/usr/bin/zsh
endif

set showmode "show what mode we are in (insert, command, visual etc)
set statusline+=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P "show full path name of the file in the status bar
set laststatus=2 "Always show the status line
"if our '{' or '}' are not in the first column for a function, use find
map [[ ?{<CR>w99[{:nohl<CR>
map ][ /}<CR>b99]}:nohl<CR>
map ]] j0[[%/{<CR>:nohl<CR>
map [] k$][%?}<CR>:nohl<CR>

filetype on "enable file specific behaviour
filetype plugin on "recognize what kind of file we are editing - c file, .h or makefile etc.
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
"leader + u to run make run on the terminal
noremap <Leader>u :!make run <enter>
"leader + r to run make report on the terminal
noremap <Leader>r :!make report <enter>
"leader + n to run make clean && make report on the terminal
noremap <Leader>n :!make clean && make report <enter>
"leader + i to run make install
noremap <Leader>i :!make install <enter>
"save current session
noremap <silent> <Leader>s :mksession <enter>
"leader + v to open myvimrc file in a vsplit
nnoremap <leader>v :vsplit ~/.myvimrc<cr>
"leader + f to invoke astyle on current file
nnoremap <leader>f :%!astyle<cr>
"leader + c in visual mode will comment out a block of lines
vmap <Leader>o <C-V>I//<Esc><Esc>

"--------------------- Vim-Plug managed plugins ------------------------------
"If vim-plug isn't installed, install it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
	"plugin installed, load plugins
	call plug#begin('~/.vim/plugged')
		" airline plugin
		Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'

		"Plugins to support snips
		Plug 'MarcWeber/vim-addon-mw-utils'
		Plug 'tomtom/tlib_vim'
		Plug 'garbas/vim-snipmate'
		Plug 'honza/vim-snippets'

		"Git plugins
		Plug 'airblade/vim-gitgutter'
		Plug 'tpope/vim-fugitive'
		Plug 'gregsexton/gitv', {'on': ['Gitv']}
        "rhubarb is used for :Gbrowse command
		Plug 'tpope/vim-rhubarb'

		"Marks :help signature
		Plug 'kshenoy/vim-signature'

        "Jump to any location within a buffer
        "s followed by two chars to jump in normal mode
        Plug 'justinmk/vim-sneak'

        "Make Org files look better
        Plug 'jceb/vim-orgmode'

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

" Snipmate settings
let g:snipMate = { 'snippet_version' : 1 }

" Airline settings
"let g:airline_section_b="" "dont show git hunks
"let g:airline_section_x="" "dont show filetype
"let g:airline_section_y="" "dont show file encoding
"let g:airline_section_z="" "dont show cursor pos info
let g:airline#extensions#tabline#enabled = 1 "enable buffer line at the top
let g:airline#extensions#tabline#buffer_min_count = 2 "show buffer line only when at least 2 buffers are open
let g:airline#extensions#tabline#buffer_idx_mode = 1 "show numbers in buffer line
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" GitGutter settings
let g:gitgutter_max_signs = 5000 "max diff of 5000 lines

"syn match cCustomFunc /\w\+\s*(/me=e-1,he=e-1
"hi def link cCustomFunc Function

" vim-sneak settings
let g:sneak#label = 1

" Add custom vim settings
source $HOME/.myvimrc
