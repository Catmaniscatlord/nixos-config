{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.sound;
in
{
  options.hosts.common.sound = {
    enable = lib.mkEnableOption "Enable sound on the machine, pipewire";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
