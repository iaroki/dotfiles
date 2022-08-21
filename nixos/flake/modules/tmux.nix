{ pkgs, ... }:

{
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
      set -g status-left " #[fg=orange]#S"
      set -g status-left-style "bold"
      set -g status-left-length 50
      set -g status-right "#[fg=#8ec07c]#H "
      set -g status-right-style "bold"
      set -g status-right-length 25
      set -g window-status-current-style "bold"
      set -g window-status-style ""
      set -g window-status-format " #[fg=#C8C093][#I]#W#F "
      set -g window-status-current-format " #[fg=#7E9CD8]#W#F "
      set -g window-status-separator ""
      set -g pane-active-border-style "fg=#DCD7BA"
      set -g pane-border-style "fg=#DCD7BA"
      setw -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -sel clip -i"
      bind P paste-buffer
    '';
  };
}
