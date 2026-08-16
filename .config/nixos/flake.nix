{
  description = "NixOS configuration derived from this dotfiles repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.ok = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager; };
        modules = [ ./hosts/ok ];
      };
    };
}
