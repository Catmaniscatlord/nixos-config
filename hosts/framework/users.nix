{	inputs,
	outputs,
	config,
  pkgs,
	... }:
{
	imports = [
		inputs.home-manager.nixosModules.home-manager
	];

  # Required for sway to be configured via home-manager (Potentiall useless)
  # security.polkit.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh; 

	users.users.david.isNormalUser = true;
	users.users.gorplet.isNormalUser = true;

	home-manager = {
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.nixvim.homeManagerModules.nixvim
      inputs.stylix.homeManagerModules.stylix
    ];

		useUserPackages = true;
		useGlobalPkgs = true;

		extraSpecialArgs = {
			inherit inputs outputs;
			nixosConfig = config;
		};

		users.david = import ../../users/david;
		users.gorplet = import ../../users/gorplet;
		users.root = import ../../users/root;
	};
}
