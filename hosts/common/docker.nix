{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.docker;
in
{
  options.hosts.common.docker = {
    enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
  };
}
