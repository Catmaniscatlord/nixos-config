{
  lib,
  pkgs,
  config,
  ...
}:
let
  filePath = /etc/nixos/hosts/homelab/forward-dns.txt;
  fileContent = builtins.readFile filePath;
  dns_forwarders = lib.lists.filter (line: line != "") (lib.strings.splitString "\n" fileContent);

  clients = config.services.openvpn.clients;
in
{
  config = {
    services.bind = {
      forwarders = dns_forwarders;
      forward = "first";
      cacheNetworks = [ "any" ];

      zones = {
        cum = {
          master = true;

          allowQuery = [ "10.11.0.0/24" ];

          file = pkgs.writeText "zone.cum" ''
            $ORIGIN cum.
            $TTL    1d
            @            IN      SOA     ns hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                        IN      NS      ns

            ns          IN      A     10.11.0.1
            ${lib.concatStrings (map (name: "${name} IN A ${clients.${name}.ip}\n") (lib.attrNames clients))}
          '';
        };

        crack = {
          master = true;

          allowQuery = [ "any" ];

          file = pkgs.writeText "zone.crack" ''
            $ORIGIN crack.
            $TTL    1d
            @            IN      SOA     ns1 hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                        IN      NS      ns

            ns          IN      A       192.168.5.230
            jellybean   IN      A       192.168.5.230
          '';
        };

      };

    };
  };
}
