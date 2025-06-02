{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./users.nix
  ];

  hosts.common = {
    ssh.enable = true;
    firewall = {
      ssh.enable = true;
      ping.enable = true;
      misc.enable = true;
    };
  };

  networking.hostName = "Jellybean";

  time.timeZone = "America/Denver";

  system.stateVersion = "24.11";
}
