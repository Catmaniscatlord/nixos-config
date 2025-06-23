{ ... }:
{
  imports = [
    ../../modules
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
