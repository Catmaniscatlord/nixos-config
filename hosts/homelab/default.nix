{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./users.nix
    ./openvpn.nix
    ./bind.nix
    ./minecraft.nix
  ];

  hosts.common = {
    docker.enable = true;
    ssh.enable = true;
    firewall = {
      ssh.enable = true;
      ping.enable = true;
      misc.enable = true;
      dns.enable = true;
      extraInputConfig = ''
        udp dport 1194 accept
        udp dport 25565 accept
        tcp dport 25565 accept
      '';

    };
  };

  boot.kernelModules = [ "tun" ];

  networking.hostName = "Jellybean";

  time.timeZone = "America/Denver";

}
