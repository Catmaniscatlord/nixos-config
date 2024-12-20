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

		Neve.url = "github:Catmaniscatlord/Neve";
		Neve.inputs.nixpkgs.follows = "nixpkgs";
		Neve.inputs.nixvim.follows = "nixvim";
	};

	outputs = { 
		nixpkgs,
		... } @ inputs: let
      commonModules = [
        inputs.sops-nix.nixosModules.sops
      ];

			mkSystem = modules:
				nixpkgs.lib.nixosSystem {
          modules = modules ++ commonModules;
					specialArgs = {inherit inputs;};
				};
	in {
		nixosConfigurations = {
			DavidFramework = mkSystem [./hosts/framework];
		}; 
	};

}