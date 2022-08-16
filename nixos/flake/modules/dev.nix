{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    go
    gopls
  ];

  programs.fzf = {
    enable = true;
  };
}
