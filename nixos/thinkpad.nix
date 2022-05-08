{ config, pkgs, ... }:

{

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "dwm";
          rev = "7ca9968358e51942084adf225c5b1cb8b8c77fee";
          sha256 = "1rhirl946jj40m856v4lvjh636fhm0q266sgrxmbz1by1ac7q2qq";
        };
      });

      st = super.st.overrideAttrs (oldAttrs: rec {
        src = super.fetchFromGitHub {
          owner = "iaroki";
          repo = "st";
          rev = "e8583132fde5e23ede931acabddc776f9a29d81c";
          sha256 = "0b0bjpih9xq39rx66hlq9gb6qpg2qzyb4564fnmkxfq806ih7mrs";
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
    pulseaudio pavucontrol pasystray dunst
  ];

  fonts.fonts = [
    pkgs.fira-mono
    pkgs.unifont
    pkgs.siji
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.slock.enable = true;
  programs.nm-applet.enable = true;

  sound.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    media-session.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            "bluez5.msbc-support" = true;
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          { "node.name" = "~bluez_input.*"; }
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbVariant = "winkeys";
  services.xserver.xkbOptions = "grp:caps_toggle";

  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.defaultSession = "none+dwm";

}
