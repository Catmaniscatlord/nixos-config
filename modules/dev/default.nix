{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.dev.tools;
in
{
  imports = [
    ./c-cpp
    ./latex
    ./kotlin
    ./python
  ];

  options.modules.dev.tools = {
    enable = lib.mkEnableOption "Install development related packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # tools
      lazygit

      # cat with syntax highlighting
      bat
    ];

    # Automatically load an environment when in a directory
    programs.direnv.enable = true;
  };
}
