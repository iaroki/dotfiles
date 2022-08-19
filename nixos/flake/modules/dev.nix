{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnumake
    go
    gopls
    gcc
  ];
}
