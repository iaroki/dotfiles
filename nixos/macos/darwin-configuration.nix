# .nixpkgs/darwin-configuration.nix

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim git home-manager
    ];

  environment.variables = { EDITOR = "vim"; };

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  programs.zsh.enable = true;  # default shell on catalina

  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.AppleShowScrollBars = "Always";
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;

  system.stateVersion = 4;
  nixpkgs.config.allowUnfree = true;
}
