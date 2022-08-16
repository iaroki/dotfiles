{ pkgs, ... }:

{
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
}
