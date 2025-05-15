{ ... }:
{
  imports = [
    ../../modules/browsers
    ../../modules/editors
    ../../modules/games
    ../../modules/shells
    ../../modules/dev
    ../../modules/media
    ../../modules/social
    ../../modules/terminals
    ../../modules/wayland
  ];

  config = {
    modules = {
      editors = {
        neovim.enable = true;
      };

      shells = {
        zsh.enable = true;
      };

      dev = {
        tools.enable = true;
      };
    };
  };
}
