{ pkgs, ... }:

{
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
}
