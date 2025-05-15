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
			profiles = displayProfiles;
		};
	};
}
