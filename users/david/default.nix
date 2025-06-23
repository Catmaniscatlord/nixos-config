{ ... }:
{
  imports = [
    ../common
    ./secrets
  ];

  modules = {
    dev.languages = {
      latex.enable = true;
      python.enable = true;
      c-cpp.enable = true;
    };

    media.sioyek.enable = true;
  };

  home.username = "david";
  home.homeDirectory = "/home/david";

  programs.home-manager.enable = true;

  home.stateVersion = "25.05"; # Current version of NixOS
}
