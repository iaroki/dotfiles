# .config/nixpkgs/home.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    htop tree wget curl bat unzip tmux ripgrep
    gnupg gopass jq yq nmap
    terraform_0_14 terragrunt terraform-docs tflint
    go python3
  ];

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName  = "iaroki";
    userEmail = "iaroki@protonmail.com";
  };

  programs.vim = {
      enable = true;
      settings = {
        relativenumber = false;
        number = true;
      };
      plugins = with pkgs.vimPlugins; [ 
        gruvbox vim-gitbranch lightline-vim rainbow
        vim-nix The_NERD_tree commentary
      ];
      extraConfig = ''
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
      '';
    };

}

