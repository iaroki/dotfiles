#!/bin/bash

TIMESTAMP="$(date +%Y_%m_%d_%H_%M_%S)"

if [ -d ~/.vim ]
then
	echo ".vim directory already present... backing it up"
	mv -v ~/.vim ~/.vim_$TIMESTAMP
fi

if [ -f ~/.vimrc ]
then
	echo ".vimrc file already present... backing it up"
	mv -v ~/.vimrc ~/.vimrc_$TIMESTAMP
fi

echo "VIM plugins initialization..."
git clone -q https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
git clone -q https://github.com/preservim/nerdtree.git ~/.vim/pack/plugins/start/nerdtree
git clone -q https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugins/start/vim-fugitive
git clone -q https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline
git clone -q https://github.com/tpope/vim-commentary.git ~/.vim/pack/plugins/start/commentary
git clone -q https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugins/start/vim-terraform
git clone -q https://github.com/Yggdroot/indentLine.git ~/.vim/pack/plugins/start/indentLine
git clone -q https://github.com/luochen1990/rainbow.git ~/.vim/pack/plugins/start/rainbow
git clone -q https://github.com/bronson/vim-trailing-whitespace.git ~/.vim/pack/plugins/start/vim-trailing-whitespace
git clone -q https://github.com/morhetz/gruvbox && mv gruvbox/{autoload,colors} ~/.vim && rm -rf gruvbox

echo "VIM config generation..."
cat > ~/.vimrc <<EOF
syntax on
set background=dark
color gruvbox
set noshowmode
set t_Co=256
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
    \ }
set enc=utf-8
set ls=2
set incsearch
set hlsearch
set nu
set scrolloff=5
set nobackup
set nowritebackup
set noswapfile
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
map <C-n> :NERDTreeToggle<CR>

autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType go setlocal commentstring=#\ %s
autocmd FileType sh setlocal commentstring=#\ %s
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType hcl setlocal commentstring=#\ %s
autocmd FileType terraform setlocal commentstring=#\ %s
autocmd FileType yaml setlocal commentstring=#\ %s
EOF

echo "Done"
