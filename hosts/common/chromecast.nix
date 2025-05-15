{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.chromecast;
in
{
  options.hosts.common.chromecast = {
    enable = lib.mkEnableOption "Enable Chromecast";
  };

  config = lib.mkIf cfg.enable {
    services.avahi.enable = true; # Chrome-cast support
  };
}
