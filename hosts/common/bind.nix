{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.ssh;
in
{
  options.hosts.common.dns = {
    enable = lib.mkEnableOption "Enable dns server";
  };

  config = lib.mkIf cfg.enable {

    services.bind = {
      enable = true;
    };
  };
}
