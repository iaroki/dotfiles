{ config, pkgs, inputs, ... }:

{
  home.username = "msytnyk";
  home.homeDirectory = "/home/msytnyk";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  imports = [
    ./modules
  ];

  nixpkgs.config.allowUnfree = true;

}
