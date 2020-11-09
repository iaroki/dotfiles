
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
    xfce.xfce4-xkb-plugin xfce.xfdashboard xorg.xhost unzip polybar bspwm
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

  services.tlp = {
    enable = true;
    settings = {

      CPU_SCALING_GOVERNOR_ON_AC="performance";
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";

        # Enable audio power saving for Intel HDA, AC97 devices (timeout in secs).
        # A value of 0 disables, >=1 enables power saving (recommended: 1).
        # Default: 0 (AC), 1 (BAT)
      SOUND_POWER_SAVE_ON_AC=0;
      SOUND_POWER_SAVE_ON_BAT=1;

        # Runtime Power Management for PCI(e) bus devices: on=disable, auto=enable.
        # Default: on (AC), auto (BAT)
      RUNTIME_PM_ON_AC="on";
      RUNTIME_PM_ON_BAT="auto";

        # Battery feature drivers: 0=disable, 1=enable
        # Default: 1 (all)
      NATACPI_ENABLE=1;
      TPACPI_ENABLE=1;
      TPSMAPI_ENABLE=1;
    };
  };

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

  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

}

