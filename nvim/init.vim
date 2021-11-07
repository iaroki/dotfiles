runtime ./plug.vim

map <C-n> :NERDTreeToggle<CR>
inoremap kj <esc>
cnoremap kj <C-C>

colorscheme gruvbox
set background=dark
set number
syntax on
set encoding=UTF-8
set laststatus=2
set noshowmode
set incsearch
set hlsearch
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set ignorecase
set smartcase
set scrolloff=8
set cursorline
set splitbelow
set splitright

let g:indentLine_color_dark = 1
let g:indentLine_char = '┊'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:rainbow_active = 1

