{ config, pkgs, ... }:

{

nixpkgs.overlays = [
  (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
      src = super.fetchFromGitHub {
        owner = "iaroki";
        repo = "dwm";
        rev = "d9aaf84d190d77a391ae4cee49d24815d5cbb4b3";
        sha256 = "0qvjqragad0bz5gj2qaxpb1wig88wmr90hkc70prz0s6y0g99sil";
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
    })
  ];

  environment.systemPackages = with pkgs; [
    xorg.xhost dmenu st dwm dwm-status xclip rofi
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
