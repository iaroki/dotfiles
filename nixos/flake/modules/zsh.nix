{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "exa -l";
      ls = "exa";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      home-switch = "home-manager switch --flake '.#nixstation' --impure";
      nixos-switch = "sudo nixos-rebuild switch --flake '.#nixstation' --impure";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "kubectl" "kubectx" "nomad" ];
      theme = "robbyrussell";
    };
  };
}
