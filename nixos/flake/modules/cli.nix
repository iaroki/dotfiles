{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    lazygit
    neovim
    scrot
    mpv
    exa
    bat
    glow
    ripgrep
    fd
    jq
    yq
    tree
    btop
    mosh
  ];

  programs.fzf = {
    enable = true;
  };
}
