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

  # Blackhole list
  rpzPath = "/var/lib/rpz/rpz.txt";
in
{
  config = {
    services.bind = {
      forwarders = dns_forwarders;
      forward = "first";
      cacheNetworks = [ "any" ];

      # Enable response policy zone (RPZ) for add blocking

      extraOptions = ''
        response-policy { zone "rpz.local"; };
      '';
      zones = {
        cum = {
          master = true;

          allowQuery = [ "10.8.0.0/24" ];

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

        # -------------------------------------------------------
        # RPZ zone — automatically updated daily
        # -------------------------------------------------------
        "rpz.local" = {
          master = true;
          file = rpzPath;
          allowQuery = [ "any" ];
        };

      };
    };

    # ---------------------------------------------------------------
    # Auto-updating blocklist generator (Steven Black / Pi-hole style)
    # ---------------------------------------------------------------
    systemd = {
      services.update-rpz = {
        description = "Update RPZ Blocklist";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };

        script = ''
          mkdir -p /var/lib/rpz
          tmpfile=$(mktemp)

          # Pi-hole / Steven Black list
          ${lib.getExe pkgs.curl} -fsSL https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts \
            | ${lib.getExe pkgs.gawk} '
                /^0\.0\.0\.0[ \t]+[A-Za-z0-9.-]+$/ {
                  domain=$2;
                  # Filter out bad entries
                  if (domain != "localhost" && domain != "0.0.0.0") {
                    print domain " CNAME .";
                  }
                }
              ' > "$tmpfile"

          # Build final RPZ file
          {
            echo '$TTL 2h'
            echo "@ IN SOA localhost. root.localhost. ("
            echo "  20250101 1h 15m 30d 2h )"
            echo "  IN NS localhost."
            echo ""
            cat "$tmpfile"
          } > ${rpzPath}

          rm "$tmpfile"
        '';

        # Make sure directory exists
        preStart = ''
          mkdir -p /var/lib/rpz
        '';
      };

      timers.update-rpz = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };

  };
}
