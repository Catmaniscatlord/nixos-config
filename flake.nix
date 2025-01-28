{
  inputs = {
    # I have 0 idea how the follows thing works along with the version pinning
    # I should probably learn how it works before this gets too complicated
    nixpkgs.url = "github:NixOs/nixpkgs/release-24.11";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.home-manager.follows = "home-manager";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      commonModules = [
        inputs.sops-nix.nixosModules.sops
        ./overlays
      ];

      mkSystem =
        modules:
        nixpkgs.lib.nixosSystem {
          modules = modules ++ commonModules;
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        DavidFramework = mkSystem [
          ./hosts/framework
          inputs.minegrub-theme.nixosModules.default
        ];
      };
    };

}
