{ config, pkgs, ... }:

{

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "dwm";
          rev = "9ff4794f73c64ec79174815c2601b6be68364f29";
          sha256 = "050hcwpp5fw8l7fqh9dayni14pxl3gkds1ljzmsq4klizhkd45al";
        };
      });

      st = super.st.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "st";
          rev = "dfdef1ae30fb02c9f70b8f241f812feba6ca6224";
          sha256 = "16a13bn7i6xr5sbzchimjc6r6fn491y3g38nqg34mr21snwnrw95";
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
    firefox remmina zathura mpv
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
