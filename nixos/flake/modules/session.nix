{ pkgs, ... }:

{
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "less -FirSwX";
    PATH = "/home/$USER/.npm-packages/bin:$PATH";
    NODE_PATH = "/home/$USER/.npm-packages/lib/node_modules";
    GTK_THEME = "Adwaita:dark";
  };
}
