call plug#begin(stdpath('data') . '/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'hashivim/vim-terraform'
Plug 'LnL7/vim-nix'
Plug 'fatih/vim-go'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'frazrepo/vim-rainbow'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'

call plug#end()

map <C-n> :NERDTreeToggle<CR>
color gruvbox
set nu
set enc=utf-8
set ls=2
set noshowmode
set incsearch
set hlsearch
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent

let g:deoplete#enable_at_startup = 1
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:rainbow_active = 1
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ 
