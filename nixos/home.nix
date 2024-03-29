{ config, pkgs, ... }:

let
  username = "msytnyk";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
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
    home.stateVersion = "22.05";
    home.packages = with pkgs; [
      tdesktop
      remmina
      scrot
      flameshot
      mpv
      exa
      bat
      glow
      fzf
      ripgrep
      fd
      jq
      yq
      tree
      lazygit
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
      kubectx
      kubernetes-helm
      go
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

    services.pasystray.enable = true;
    services.blueman-applet.enable = true;

    programs.rofi = {
      enable = true;
      theme = "DarkBlue";
    };

    programs.firefox = {
      enable = true;
      profiles.firenix = {
        settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
          /* hides the native tabs */
          #TabsToolbar {
            visibility: collapse;
          }

          #titlebar {
            visibility: collapse;
          }

          #sidebar-header {
            visibility: collapse !important;
          }
        '';
      };
    };

    home.sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      MANPAGER = "less -FirSwX";
      PATH = "/home/${username}/.npm-packages/bin:$PATH";
      NODE_PATH = "/home/${username}/.npm-packages/lib/node_modules";
      GTK_THEME = "Adwaita:dark";
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
        plugins = [ "aws" "kubectl" "kubectx" "nomad" ];
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

    programs.zathura = {
        enable = true;
        options = {
          notification-error-bg   = "#f44747";
          notification-error-fg   = "#DCD7BA";
          notification-warning-bg = "#dcdcaa";
          notification-warning-fg = "#11121D";
          notification-bg         = "#11121D";
          notification-fg         = "#af88F1";

          completion-bg           = "#2d2d30";
          completion-fg           = "#DCD7BA";
          completion-group-bg     = "#2d2d30";
          completion-group-fg     = "#DCD7BA";
          completion-highlight-bg = "#062c45";
          completion-highlight-fg = "#DCD7BA";

          index-bg                = "#11121D";
          index-fg                = "#DCD7BA";
          index-active-bg         = "#af88e1";
          index-active-fg         = "#282a36";

          inputbar-bg             = "#ffaf00";
          inputbar-fg             = "#11121D";
          statusbar-bg            = "#11121D";
          statusbar-fg            = "#ffffff";

          highlight-color         = "#264f78";
          highlight-active-color  = "#dcdcaa";

          default-bg              = "#11121D";
          default-fg              = "#DCD7BA";

          render-loading          = true;
          render-loading-fg       = "#11121D";
          render-loading-bg       = "#DCD7BA";

          recolor-lightcolor      = "#1F1F28";
          recolor-darkcolor       = "#DCD7BA";

          recolor                 = true;
          };
    };

    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
      extraPackages = with pkgs; [ imv mediainfo mktemp ];
      plugins = {
        mappings = {
          o = "fzopen";
          f = "finder";
          i = "imgview";
          p = "preview-tui";
        };
        src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.6";
          sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
        }) + "/plugins";
      };
    };

    home.file.dwm_autostart = {
        executable = true;
        target = ".config/dwm/autostart.sh";
        text = ''
          slstatus &
        '';
      };

  };
}
