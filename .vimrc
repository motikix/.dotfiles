set shortmess+=I
set shortmess-=S

set noerrorbells
set novisualbell
set t_vb=
set belloff=all

set enc=utf8
set fenc=utf8
set fencs=utf8,ms932,cp932,sjis,eucjp-ms,eucjp,latin1
set ffs=unix,dos,mac

set nobackup
set noswapfile

set number
set relativenumber

set ambiwidth=single
set hidden
set autoread
set showcmd

set tabstop=2
set softtabstop=-1
set shiftwidth=0
set smarttab
set expandtab
set autoindent
set smartindent

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

set clipboard=unnamed,unnamedplus

set splitbelow
set splitright

nnoremap <silent> <C-w>N :vnew<CR>
nnoremap <silent> <C-[> :nohl<CR><ESC>

syntax on
