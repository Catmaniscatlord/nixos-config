{
  config,
  lib,
  displayProfiles,
  ...
}:
let
  cfg = config.modules.wayland;
in
{
  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      # If you are erroring here with home manager, look at hosts/framework/display profiles for an example
      # of what to do to fix it
      settings = displayProfiles.output;
    };
  };
}
