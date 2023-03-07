{
  description = "Home Manager configuration of remotestation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    note-sync.url = "github:iaroki/note-sync";
  };

  outputs = { self, nixpkgs, home-manager, note-sync, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.msytnyk = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs.inputs = attrs;
        modules = [
          ./home.nix
        ];
      };
    };
}
