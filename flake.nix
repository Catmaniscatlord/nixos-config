{
  inputs = {
    # I have 0 idea how the follows thing works along with the version pinning
    # I should probably learn how it works before this gets too complicated
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    minegrub-theme.url = "github:Lxtharia/minegrub-theme";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      commonModules = [
        inputs.sops-nix.nixosModules.sops
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

        Jellybean = mkSystem [
          ./hosts/homelab
          inputs.minegrub-theme.nixosModules.default
          inputs.nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
      };
    };

}
