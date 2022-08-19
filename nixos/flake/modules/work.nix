
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    terraform
    terraform-docs
    terraform-ls
    tflint
    terragrunt
    ansible
    ansible-lint
    sshpass
    awscli2
    kubectl
    kubectx
    kubernetes-helm
    python39
    python39Packages.pip
    nodejs
    nodePackages.npm
    nodePackages.pyright
  ];
}
