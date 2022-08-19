{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    extensions = with config.nur.repos.rycee.firefox-addons; [
      ublock-origin
      darkreader
      h264ify
      multi-account-containers
      tree-style-tab
      vimium
      auto-tab-discard
    ];
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
}
