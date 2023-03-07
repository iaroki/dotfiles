{ pkgs, ... }:

{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
