{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./dwm.nix
    # ./xfce.nix
    ./remote.nix
    ./vmware.nix
  ];

  environment.systemPackages = with pkgs; [
  vim wget tmux git htop tree unzip
  ];

  networking.hostName = "nixstation";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 7777 ]; # web expose
  networking.firewall.allowedTCPPorts = [ 60000 60001 ]; # mosh-server

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Europe/Kiev";

  environment.homeBinInPath = true;
  programs.vim.defaultEditor = true;
  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
}
