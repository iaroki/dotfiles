{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  firefox remmina zathura mpv xorg.xhost
  xfce.xfce4-battery-plugin xfce.xfce4-clipman-plugin xfce.xfce4-datetime-plugin
  xfce.xfce4-xkb-plugin xfce.xfdashboard
  ];

  fonts.fonts = [
    pkgs.fira-mono
    pkgs.unifont
    pkgs.siji
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.slock.enable = true;
  programs.nm-applet.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbVariant = "winkeys";
  services.xserver.xkbOptions = "grp:caps_toggle";

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.thunarPlugins = [ pkgs.xfce.thunar-archive-plugin pkgs.xfce.thunar-volman ];
  services.xserver.displayManager.defaultSession = "xfce";
}
