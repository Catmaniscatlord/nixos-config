{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hosts.common.printing;
in
{
  options.hosts.common.printing = {
    enable = lib.mkEnableOption "Enable printing on the machine";
  };

  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;

      drivers = with pkgs; [
        cups
        cups-filters
        cups-browsed
        cnijfilter2 # Canon
      ];

      # Enable Avahi/mDNS printer discovery
      browsing = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
