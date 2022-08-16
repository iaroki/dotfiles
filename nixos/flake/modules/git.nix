{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Maxim Sytnyk";
    userEmail = "iaroki@protonmail.com";
    signing = {
      key = "F3456398396F1A5E";
      signByDefault = false;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      color.ui = true;
      core.askPass = "";
      credential.helper = "store";
      github.user = "iaroki";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };
}
