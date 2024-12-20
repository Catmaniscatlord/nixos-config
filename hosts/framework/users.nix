{	inputs,
	outputs,
	config,
	... }:
{
	imports = [
		inputs.home-manager.nixosModules.home-manager
	];

	users.users.david.isNormalUser = true;

	home-manager = {
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.nixvim.homeManagerModules.nixvim
    ];

		useUserPackages = true;
		useGlobalPkgs = true;

		extraSpecialArgs = {
			inherit inputs outputs;
			nixosConfig = config;
		};

		users.david = import ../../users/david;
		users.root = import ../../users/root;
	};
}
