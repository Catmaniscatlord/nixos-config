{ ... }:
{
  imports = [
    ../common
  ];

  home.username = "gorplet";
  home.homeDirectory = "/home/gorplet";

  programs.home-manager.enable = true;

  home.stateVersion = "25.05"; # Current version of NixOS
}
