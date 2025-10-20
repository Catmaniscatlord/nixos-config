{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./users.nix
    ./openvpn.nix
    ./bind.nix
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

        iifname tun0 accept
      '';

      extraForwardConfig = ''
        iifname "tun0" oifname "tun0" accept
      '';
    };
  };

  networking.hostName = "Jellybean";

  time.timeZone = "America/Denver";

}
