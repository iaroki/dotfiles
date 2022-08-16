{ pkgs, ... }:

{
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
}
