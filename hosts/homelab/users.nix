{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users = {
    david = {
      isNormalUser = true;
      extraGroups = [
        "video"
        "networkmanager"
        "wheel"
      ];
    };
    remy = {
      isNormalUser = true;
      extraGroups = [
        "video"
        "networkmanager"
        "wheel"
      ];
    };
  };

  home-manager = {
    sharedModules = [
      inputs.sops-nix.homeModules.sops
      inputs.nixvim.homeModules.nixvim
      inputs.stylix.homeModules.stylix
    ];

    useUserPackages = true;
    useGlobalPkgs = true;

    extraSpecialArgs = {
      inherit inputs outputs;
    };

    users.david = {
      imports = [
        ../../users/common/base.nix
      ];

      modules = {
        dev.languages = {
          python.enable = true;
          c-cpp.enable = true;
        };

        terminals.kitty.enable = true;
      };

      home.username = "david";
      home.homeDirectory = "/home/david";

      programs.home-manager.enable = true;

      home.stateVersion = "25.05";
    };

    users.remy = {
      imports = [
        ../../users/common/base.nix
      ];

      home.username = "remy";
      home.homeDirectory = "/home/remy";

      programs.home-manager.enable = true;

      home.stateVersion = "25.05";
    };

    users.root = {
      imports = [
        # base doesn't have a lot of user things
        ../../users/common/base.nix
      ];

      home.username = "root";
      home.homeDirectory = "/root";

      programs.home-manager.enable = true;

      home.stateVersion = "25.05"; # Current version of NixOS

      programs.git = {
        enable = true;
        userName = "jellybean";
        userEmail = "root@jellybean";
      };
    };
  };
}
