{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.bluetooth;
in
{
  options.hosts.common.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth on the machine";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}
