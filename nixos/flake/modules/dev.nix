{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    go
    gopls
    gcc
  ];

  programs.fzf = {
    enable = true;
  };
}
