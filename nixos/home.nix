{ config, pkgs, ... }:

let
  username = "msytnyk";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in

{
  imports = [
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  users.users."${username}" = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${username}";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keyFiles = [ /etc/nixos/ssh/authorized_keys ];
  };

  home-manager.users."${username}" = {
    home.packages = with pkgs; [
      firefox
      tdesktop
      remmina
      zathura
      scrot
      mpv
      exa
      bat
      fzf
      ripgrep
      fd
      jq
      yq
      tree
      unstable.neovim
      gnumake
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
      kubernetes-helm
      go_1_17
      gopls
      gotags
      ctags
      python39
      python39Packages.pip
      nodejs
      nodePackages.npm
      nodePackages.pyright
      gcc
      skopeo
      buildah
      mosh
    ];

    home.sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      MANPAGER = "less -FirSwX";
      PATH = "/home/${username}/.npm-packages/bin:$PATH";
      NODE_PATH = "/home/${username}/.npm-packages/lib/node_modules";
    };

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
      };
      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "robbyrussell";
      };
    };

    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };

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

    programs.tmux = {
      enable = true;
      terminal = "xterm-256color";
      secureSocket = false;
      extraConfig = ''
        set -g status-position bottom
        set -g status-justify centre
        set -g status-style "bg=#1F1F28"
        set -g window-style ""
        set -g window-active-style ""
        set -g status-left " #[fg=#8ec07c]#S"
        set -g status-left-style ""
        set -g status-left-length 50
        set -g status-right "%a %d %b #[fg=#8ec07c]%R %Z "
        set -g status-right-style "fg=#DCD7BA"
        set -g status-right-length 25
        set -g window-status-current-style "bold"
        set -g window-status-style "fg=#DCD7BA"
        set -g window-status-format " #[fg=#C8C093]#{?#{==:#W,zsh},[#I]#{b:pane_current_path},#W}#F "
        set -g window-status-current-format " #[fg=#C8C093]#{?#{==:#W,zsh},#{b:pane_current_path},#W}#F "
        set -g window-status-separator ""
        set -g pane-active-border-style "fg=#DCD7BA"
        set -g pane-border-style "fg=#DCD7BA"
        setw -g mode-keys vi
        bind -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -sel clip -i"
        bind P paste-buffer
      '';
    };
  };
}
