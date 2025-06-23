{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.shells.zsh;
in
{
  options.modules.office = {
    libre.enable = lib.mkEnableOption "Enable libre office";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      libreoffice
    ];

  };

}
