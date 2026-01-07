{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.office.zoom;
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
