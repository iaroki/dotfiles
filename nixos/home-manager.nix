
{ config, pkgs, ... }:

let userName = "msytnyk";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot-loader.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
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
    xfce.xfce4-xkb-plugin xfce.xfdashboard xorg.xhost unzip polybar bspwm sxhkd
    jetbrains.idea-ultimate
  ];

  environment.homeBinInPath = true;

  fonts.fonts = [ pkgs.fira-mono pkgs.unifont pkgs.siji ];

  programs.slock.enable = true;
  programs.nm-applet.enable = true;
  programs.vim.defaultEditor = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,ru";
  services.xserver.xkbVariant = "winkeys";
  services.xserver.xkbOptions = "grp:win_space_toggle";

  # Enable touchpad support.
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.thunarPlugins = [ pkgs.xfce.thunar-archive-plugin pkgs.xfce.thunar-volman ];
  services.xserver.displayManager.defaultSession = "xfce";

  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.bspwm.configFile = "/home/${userName}/.config/bspwm/bspwmrc";
  services.xserver.windowManager.bspwm.sxhkd.configFile= "/home/${userName}/.config/sxhkd/sxhkdrc";


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
  users.users.${userName} = {
    isNormalUser = true;
    createHome = true;
    home = "/home/${userName}";
    password = "max";
    extraGroups = [ "wheel" "video" "camera" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };

# HOME MANAGER
  home-manager.users.${userName} = { ... }: {
    programs.git = {
    enable = true;
    userName  = "iaroki";
    userEmail = "iaroki@protonmail.com";
    };

    programs.vim = {
      enable = true;
      settings = {
        relativenumber = false;
        number = true;
      };
      plugins = with pkgs.vimPlugins; [ gruvbox vim-gitbranch lightline-vim rainbow The_NERD_tree commentary ];
      extraConfig = ''
syntax on
set background=dark
color gruvbox
set noshowmode
set t_Co=256
let g:rainbow_active = 1
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name'
    \ },
    \ }
set enc=utf-8
set ls=2
set incsearch
set hlsearch
set nu
set scrolloff=5
set nobackup
set nowritebackup
set noswapfile
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
map <C-n> :NERDTreeToggle<CR>
      '';
    };

    home.file = {

      "/home/${userName}/.config/bspwm/bspwmrc" = {
      executable = true;
      text = ''
#!/bin/sh

sxhkd &
polybar thinkpad &

bspc monitor -d I II III IV V VI VII VIII IX X

bspc config border_width         1
bspc config window_gap          1

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Firefox desktop='^2'
bspc rule -a mpv state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off
      '';
      };

      "/home/${userName}/.config/sxhkd/sxhkdrc" = {
      text = ''
#
# wm independent hotkeys
#

# terminal emulator
#super + Return
alt + F1
    xfce4-terminal

# program launcher
#super + @space
alt + F2
	rofi -show run

# File manager
alt + F3
    thunar

# Volume UP
XF86AudioRaiseVolume
    pactl set-sink-volume 0 +10%

# Volume DOWN
XF86AudioLowerVolume
    pactl set-sink-volume 0 -10%

# Volume MUTE
XF86AudioMute
    pactl set-sink-mute 0 toggle

# Screen lock
super + less
    slock

alt + l
    slock

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#
# bspwm hotkeys
#

# quit/restart bspwm
super + alt + {q,r}
	bspc {quit,wm -r}

# close and kill
super + {_,shift + }w
	bspc node -{c,k}

alt + F4
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local

# swap the current node and the biggest node
super + g
	bspc node -s biggest

#
# state/flags
#

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

#
# focus/swap
#

# focus the node in the given direction
super + {_,shift + }{h,j,k,l}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous node in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local

alt + {_,shift + }Tab
	bspc node -f {next,prev}.local

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#
# preselect
#

# preselect the direction
super + ctrl + {h,j,k,l}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel

# cancel the preselection for the focused desktop
super + ctrl + shift + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

#
# move/resize
#

# expand a window by moving one of its side outward
super + alt + {h,j,k,l}
	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# contract a window by moving one of its side inward
super + alt + shift + {h,j,k,l}
	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# move a floating window
super + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}
      '';
      };

      "/home/${userName}/.config/xfce4/terminal/colorschemes/gruvbox.theme" = {
        text = ''
[Scheme]
Name=Gruvbox (dark)
ColorForeground=#f2f2e5e5bcbc
ColorBackground=#323230302f2f
ColorCursor=#d65bc4cd8ca1
ColorPalette=#323230302f2f;#cccc24241d1d;#989897971a1a;#d7d799992121;#454585858888;#b1b162628686;#68689d9d6a6a;#f2f2e5e5bcbc;#1d1d20202121;#fbfb49493434;#b8b8bbbb2626;#fafabdbd2f2f;#8383a5a59898;#d3d386869b9b;#8e8ec0c07c7c;#fffff1f1c6c6
        '';
      };

      "/home/${userName}/.config/xfce4/terminal/terminalrc" = {
        text = ''
[Configuration]
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBellUrgent=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=FALSE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=FALSE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=FALSE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=FALSE
MiscSearchDialogOpacity=100
MiscShowUnsafePasteDialog=FALSE
ScrollingBar=TERMINAL_SCROLLBAR_NONE
ScrollingUnlimited=TRUE
FontName=Fira Mono 14
ColorPalette=#073642;#dc322f;#859900;#b58900;#268bd2;#d33682;#2aa198;#eee8d5;#002b36;#cb4b16;#586e75;#657b83;#839496;#6c71c4;#93a1a1;#fdf6e3
ColorForeground=#073642
ColorBackground=#eeeeeeeeecec
ColorCursor=#073642
ColorBold=#073642
ColorBoldUseDefault=FALSE
TabActivityColor=#dc322f
ShortcutsNoMenukey=TRUE
ShortcutsNoMnemonics=TRUE
ShortcutsNoHelpkey=TRUE
      '';
      };

};
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

}

