{ config, pkgs, ... }:

{
  imports = [
    ./dwm.nix
    ./vmware.nix
  ];

  environment.systemPackages = with pkgs; [
  vim wget tmux git htop tree unzip home-manager
  ];

  networking.hostName = "nixstation";
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
    description = "msytnyk";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "docker" "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
