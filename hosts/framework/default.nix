{ ... }:
{
  imports = [
    ../common # Common goes first, its options my be overridden by later imports.
    ./hardware-configuration.nix
    ./users.nix
  ];

  hosts.common = {
    battery_monitor.enable = true;
    bluetooth.enable = true;
    chromecast.enable = true;
    firewall = {
      spotifyLocalDiscovery.enable = true;
      ping.enable = true;
    };
    fprintd.enable = true;
    printing.enable = true;
    regreet.enable = true;
    sound.enable = true;
  };

  networking.hostName = "DavidFramework";

  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
  ];

  # time.timeZone = "America/Denver";
  services.automatic-timezoned.enable = true;
}
