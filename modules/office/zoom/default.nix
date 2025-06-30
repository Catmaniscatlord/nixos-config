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
    zoom.enable = lib.mkEnableOption "Enable zoom";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zoom-us
    ];
  };

}
