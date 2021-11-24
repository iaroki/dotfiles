{ config, pkgs, ... }:

{
  imports = [ ./home.nix ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Kiev";

  environment.systemPackages = with pkgs; [
  wget vim tmux git htop tree unzip
  ];

  environment.homeBinInPath = true;
  programs.vim.defaultEditor = true;

  users.users.msytnyk = {
      isNormalUser = true;
      createHome = true;
      home = "/home/msytnyk";
      extraGroups = [ "wheel" "docker" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
}