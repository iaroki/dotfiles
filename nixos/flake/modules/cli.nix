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
  ];

  programs.fzf = {
    enable = true;
  };
}
