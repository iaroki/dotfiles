
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot-loader.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Kiev";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim tmux git firefox remmina mpv htop xarchiver vagrant tdesktop tree rofi
    xfce.xfce4-battery-plugin xfce.xfce4-clipman-plugin xfce.xfce4-datetime-plugin
    xfce.xfce4-embed-plugin xfce.xfce4-namebar-plugin xfce.xfce4-netload-plugin
    xfce.xfce4-sensors-plugin xfce.xfce4-systemload-plugin xfce.xfce4-verve-plugin
    xfce.xfce4-weather-plugin xfce.xfce4-xkb-plugin xfce.xfdashboard xorg.xhost
  ];

  environment.homeBinInPath = true;

  fonts.fonts = [ pkgs.fira-mono ];

  programs.slock.enable = true;
  programs.nm-applet.enable = true;
  programs.vim.defaultEditor = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.defaultSession = "xfce";
  services.xserver.desktopManager.xfce.thunarPlugins = [ pkgs.xfce.thunar-archive-plugin pkgs.xfce.thunar-volman ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.msytnyk = {
    isNormalUser = true;
    createHome = true;
    home = "/home/msytnyk";
    password = "max";
    extraGroups = [ "wheel" "video" "camera" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
#  virtualisation.virtualbox.host.enableExtensionPack = true;

  system.stateVersion = "20.03"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true;

}

