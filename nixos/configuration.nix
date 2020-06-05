
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    wget vim tmux git firefox bspwm sxhkd polybar dmenu slock remmina mpv zathura htop
  ];

  environment.homeBinInPath = true;

  fonts.fonts = [ pkgs.fira-mono ];

  hardware.acpilight.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  

  programs.gphoto2.enable = true;
  programs.light.enable = true;
  programs.nm-applet.enable = true;
  programs.slock.enable = true;
  programs.vim.defaultEditor = true;

  services.acpid.enable = true;
  services.tlp.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.defaultSession = "xfce";
  services.xserver.windowManager.bspwm.enable = true;
#  services.xserver.windowManager.bspwm.configFile = "";
#  services.xserver.windowManager.bspwm.sxhkd.configFile = "";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.msytnyk = {
    isNormalUser = true;
    createHome = true;
    home = "/home/msytnyk";
    password = "max";
    extraGroups = [ "wheel" "video" "camera" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXD/fD3gcDWQiCsEz5yoNewLN669FHhz9t+2RkTHXGaFp9w3VBDcZeCfcqx/0oFLvUoH8XRUV9xdNJp94YuLFLGrto5vf0bQrLn8YAS9U++pfrY1oyMYyZcfm4vwz192xerPutchBNv33hHNQoTM/dx9Ef/9DLnJE5zPkH1AR+MuizH/639S+0MGz2fMRSCP27WQDPo21N+n5W0CHNx522FgWwO4p2887F36Y/WvRD+SdNtk1soB39C2fQGkxWKCj8yK2aSfytDDpglJZMb3BcJeTc/tFRBW/la3SSRHRJmbxkt2QmOJFPriioZuaWfZFwRl/nXM78MPor0wlHwy5gQmA7S48sQGlKMsF+NcUyaGjVHvCJtCYY87h6hk1OYblwZMurj9RzmGC/VawkY3aMer5QzXIC+59SquhKFHw6hHSUuRMBTMQJJq9edqpu0cndvx/K2L6e16mzhskZ+YEo5y5EfipkXT51vwdVXX3DSEsYdgvlSS3c7n6pqZTZgML0Abmjc/o1ecwV6PH0ZSyD2oCfwEsZXmFeX0+dUnGO5KvTiecm2dNhGpzdJguYrmbBZogSbxlA6Wha6Q4kawceQn4kipml2evwAvEPkj24xVjGfXFJQ/S8qlsWnxx64to2vMsDXV2NbOcg8LFgcM5nHg6are25a38DTpCGPQxYdQ== iaroki@protonmail.com" ];
  };

  virtualisation.docker.enable = true;
#  virtualisation.virtualbox.host.enable = true;
#  virtualisation.virtualbox.host.enableExtensionPack = true;

  system.stateVersion = "20.03"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true;

}

