{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # notification manager developed by swaywm maintainer
    services = {
      mako = {
        enable = true;
        settings = {
          actions = true;
          anchor = if cfg.sway.enable then "top-right" else "top-right";
          # borderRadius = 8;
          # borderSize = 1;
          defaultTimeout = 5000;
          icons = true;
          layer = "overlay";
          maxVisible = 3;
          padding = "10";
          # width = 300;
        };
      };
    };
  };
}
