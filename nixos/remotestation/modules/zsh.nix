{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    initExtra = ''
      bindkey jk vi-cmd-mode
      zstyle ':completion::complete:make:*:targets' call-command true
    '';
    localVariables = {
        VI_MODE_SET_CURSOR = true;
      };
    shellAliases = {
      vim = "nvim";
      ll = "exa -l";
      ls = "exa";
      lg = "lazygit";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      gwl = "git worktree list";
      gwa = "git worktree add";
      gwr = "git worktree remove";
      n = "nnn -edaPp";
      home-switch = "home-manager switch --flake '.#nixstation' --impure";
      nixos-switch = "sudo nixos-rebuild switch --flake '.#nixstation' --impure";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "kubectl" "kubectx" "vi-mode" ];
      theme = "robbyrussell";
    };
  };
}
