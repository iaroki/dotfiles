{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    lazygit
    lazydocker
    exa
    bat
    glow
    ripgrep
    fd
    jq
    yq
    tree
    htop
    btop
    bottom
    cbonsai
    unzip
    mosh
    just
    gnumake
    go
    gopls
    gcc
    terraform
    terraform-docs
    terraform-ls
    tflint
    terragrunt
    shellcheck
    ansible
    ansible-lint
    sshpass
    awscli2
    kubectl
    kubectx
    kubernetes-helm
    python310
    python310Packages.pip
    python310Packages.toggl-cli
    nodejs
    nodePackages.npm
    nodePackages.pyright
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    cmake-language-server
  ];

  programs.fzf = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
