{
  description = "nixstation";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      hostname = "nixstation";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = attrs;
        modules = [ ./configuration.nix ];
      };
      homeConfigurations.${hostname} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
