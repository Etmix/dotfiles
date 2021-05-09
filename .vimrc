if !exists("mapleader")
  let mapleader = "\<Space>"
endif

set wildignore+=*/min/*,*/vendor/*,*/node_modules/*,*/bower_components/*,*/dist/*,/*target/*,*.min.js

if has("gui_running")
    set guioptions -=m
    set guioptions -=T
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
endif

" utf-8
scriptencoding utf-8
set encoding=utf-8

" colors
set termguicolors
" colorscheme blame

" arrow keys resize window
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" Personal preferences
set history=5000
set showcmd
set wildignorecase
set nojoinspaces
set complete-=t
set foldlevelstart=99
set noswapfile
if has('mouse')
  set mouse=nv
endif
set diffopt=filler,vertical
set ruler
set hidden
set nocompatible
filetype indent on
syntax on
set hidden
set wildmenu
set showcmd
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set tabstop=2
set shiftwidth=2
set softtabstop=2

set expandtab
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

set belloff=all
set visualbell t_vb=
if has("autocmd") && has("gui")
    au GUIEnter * set t_vb=
endif
