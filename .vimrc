nnoremap <SPACE> <Nop>
if !exists("mapleader")
  let mapleader = "\<Space>"
endif

"set path=.,,**
set path=.,,$PWD/**
set wildignore+=**/node/**,**/build/**,**/min/**,**/vendor/**,**/node_modules/**,**/bower_components/**,**/dist/**,/**target/**,**.min.js,**.min.css,**.class
set wildignore+=*.swp,*.bak
set wildignore+=*.pyc,*.class,*.sln,*.Master,*.csproj,*.csproj.user,*.cache,*.dll,*.pdb,*.min.*
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/*
set wildignore+=tags
set wildignore+=*.tar.*

" remove all existing autocmds
autocmd!

" use 256 colors in terminal
"if !has("gui_running")
"    set t_Co=256
"    set term=screen-256color
"endif

" ------------- make copy and paste work in wsl using the system clipboard -------------
" win32yank.exe needs to be in Windows system path (e.g. copy exe to C:/Windows/System32).
function! Paste(mode)
    let @" = system('win32yank.exe -o --lf')
    return a:mode
endfunction

map <expr> p Paste('p')
map <expr> P Paste('P')

autocmd TextYankPost * call YankDebounced()

function! Yank(timer)
    call system('win32yank.exe -i --crlf', @")
    redraw!
endfunction

let g:yank_debounce_time_ms = 0
let g:yank_debounce_timer_id = -1

function! YankDebounced()
    let l:now = localtime()
    call timer_stop(g:yank_debounce_timer_id)
    let g:yank_debounce_timer_id = timer_start(g:yank_debounce_time_ms, 'Yank')
endfunction
" --------- end copy paste stuff -------------


" colors
"set background=dark
"set termguicolors
"autocmd vimenter * ++nested colorscheme solarized8
colorscheme lucius
LuciusDarkLowContrast

if has("gui_running")
  set guioptions -=m
  set guioptions -=T
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
endif

" Function to trim extra whitespace in whole file
function! Trim()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun
command! -nargs=0 Trim call Trim()

" make common mistypes work
command Wa wa
command WA wa

" switch between buffers the smart way
nnoremap gb :ls<CR>:b<Space>

" Move around splits the smart way
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
noremap <Leader>y "+y
noremap <Leader>p "+p

" switch between the current and the last buffer more conveniently
nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
" taken from Gary Bernhardt's vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

"switch between html and ts of angular component
function! SwitchHtmlTs()
  if (expand ("%:e") == "ts")
    e %:r.html
  else
    e %:r.ts
  endif
endfunction
autocmd BufNewFile,BufRead *.ts   nnoremap <silent><buffer> <LEADER>s :<C-u>call SwitchHtmlTs()<CR>
autocmd BufNewFile,BufRead *.html nnoremap <silent><buffer> <LEADER>s :<C-u>call SwitchHtmlTs()<CR>

" arrow keys resize window
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" utf-8
scriptencoding utf-8
set encoding=utf-8

" Personal preferences
set clipboard=unnamed,unnamedplus
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set history=5000
set wildignorecase
set nojoinspaces
"set complete-=t
set foldlevelstart=99
set noswapfile
if has('mouse')
  set mouse=nv
endif
set diffopt=filler,vertical
set hidden
set nocompatible
filetype indent on
syntax on
set hidden
set wildmenu
set wildmode=longest,list
set showcmd
set incsearch
set hlsearch
set showmatch
set ignorecase
set smartcase
set cursorline
set switchbuf=useopen
set backspace=indent,eol,start
set autoindent
set nostartofline
set laststatus=2
set confirm
set visualbell
set t_vb=
set cmdheight=2
set timeout timeoutlen=1000 ttimeoutlen=100
set modeline
set foldmethod=manual
set nojoinspaces
set nofoldenable
let g:sh_noisk=1
set signcolumn=no
set termguicolors
set modelines=3
set pastetoggle=<F11>
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set fileformat=unix
set fileformats=unix,dos
set scrolloff=3
set winwidth=79
set showtabline=2
set shell=bash
set updatetime=200
set completeopt=menu,preview
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set autoread
syntax on
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

set belloff=all
set visualbell t_vb=
if has("autocmd") && has("gui")
  au GUIEnter * set t_vb=
endif


" ================================================================================
" Use heatseaker and find (dir on windows) to find files
" ================================================================================
function! HeatseekerCommand(choice_command, hs_args, first_command, rest_command)
    try
        let filenames = system(a:choice_command)

        " catch errors for empty directories and don't open the error as a filename
        if filenames =~ '^Datei nicht gefunden' || filenames =~ '^File Not Found'
          return
        endif

        let selections = system("hs " . a:hs_args, filenames)
    catch /Vim:Interrupt/
        redraw!
        return
    endtry
    redraw!
    let first = 1
    for selection in split(selections, "\n")
        if first
            exec a:first_command . " " . selection
            let first = 0
        else
            exec a:rest_command . " " . selection
        endif
    endfor
endfunction

if has('win32')
    nnoremap <leader>f :call HeatseekerCommand("dir /a-d /s /b", "", ':e', ':tabe')<CR>
else
    " We go through Windows cmd to list the files. WSL performance is really bad in ntfs...
    " Observe the awesomeness
    " TODO: Get Windows (dir) to filter the files, so that it doesn't go through the folders we ignore anyway. That should give us a big performance boost.
    nnoremap <silent><leader>f :call HeatseekerCommand("cmd.exe /c dir /a-d /s /b \| grep -Ev '\\\\node_modules\\\\\|\\\\target\\\\\|\\\\.git\\\\\|\\\\dist\\\\\|\\\\build\\\\\|\\\\node\\\\\|\\\\.settings\\\\' \| sed -e 's\|\\\\\|/\|g' \| sed -e 's\|\\([A-Z]\\):\|/mnt/\\l\\1\|'", '', ':e', ':tabe')<CR>
    " (I hate Windows.)
    " (And node_modules)

    " we would do this in linux
    "nnoremap <leader>f :call HeatseekerCommand("find . ! -path '*/.git/*' ! -path '*/node_modules/*' ! -path '*/node/*' ! -path '*/target/*' ! -path '*/dist/*' -type f -follow", "", ':e', ':tabe')<cr>
endif

" ================================================================================
" Use heatseaker to search buffers
" ================================================================================
function! HeatseekerBuffer()
    let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
    let buffers = map(bufnrs, 'bufname(v:val)')
    let named_buffers = filter(buffers, '!empty(v:val)')
    if has('win32')
        let filename = tempname()
        call writefile(named_buffers, filename)
        call HeatseekerCommand("type " . filename, "", ":b", ":b")
        silent let _ = system("del " . filename)
    else
        call HeatseekerCommand('echo "' . join(named_buffers, "\n") . '"', "", ":b", ":b")
    endif
endfunction

" Fuzzy select a buffer. Open the selected buffer with :b.
nnoremap <leader>b :call HeatseekerBuffer()<cr>
" ================================================================================
