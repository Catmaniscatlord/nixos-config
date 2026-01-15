{
  imports = [
    # base doesn't have a lot of user things
    ../common/base.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11"; # Current version of NixOS
}
