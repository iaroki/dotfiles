{ pkgs, ... }:

{
  home.file.dwm_autostart = {
      executable = true;
      target = ".config/dwm/autostart.sh";
      text = ''
        slstatus &
	xrandr -s 2880x1674
      '';
    };
}
