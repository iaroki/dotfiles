{ config, pkgs, ... }:

let
    unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in

{
  imports = [ 
    ./home.nix
    ./dwm.nix
    ./vmware.nix
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
  vim wget tmux git htop tree unzip unstable.neovim
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Kiev";

  environment.homeBinInPath = true;
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;

  users.users.msytnyk = {
      isNormalUser = true;
      createHome = true;
      home = "/home/msytnyk";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
}
