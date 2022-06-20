{ config, pkgs, ... }:

{

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "dwm";
          rev = "4323c4b5977e0c5d5dea4ca13858e1e632ed11ed";
          sha256 = "GZyHEFNB4Nj8+Q2XQnKoeOMC7tJRvNUJqmuV0LKcQV4=";
        };
      });

      st = super.st.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "st";
          rev = "35d09cfe777735862da86e2e86e3225b08d7163a";
          sha256 = "mWpcnJfCt3oRbBc1jfYd9LqALelZZHRqhEO6Bm6UjCQ=";
        };
        buildInputs = oldAttrs.buildInputs ++  [ super.harfbuzz ];
      });

      slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "slstatus";
          rev = "de91b3f738fcd42f88ad4653c3ac20ab1564961d";
          sha256 = "00lpdw1d4r1sn4ccw4dr5qw7m7fcv19ma1ajw5jbm6vcpnm9x74f";
        };
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    xorg.xhost dmenu st dwm slstatus xclip rofi
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

  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.defaultSession = "none+dwm";

  services.xserver.dpi = 220;

}
