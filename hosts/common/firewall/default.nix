{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.firewall;

  ping = ''
    # allow "ping"
    ip6 nexthdr icmpv6 icmpv6 type echo-request accept
    ip protocol icmp icmp type echo-request accept
  '';

  spotify = ''
    # sync local tracks from your filesystem with mobile devices in the same network
    tcp dport 57621 accept
    # discovery of Google Cast devices (and possibly other Spotify Connect devices) in the same network by the Spotify app
    udp dport 5353 accept 
  '';

  ssh = ''
    # allow ssh
    tcp dport 22 accept
    tcp dport 2222 accept
  '';

in
{
  options.hosts.common.firewall = {
    spotifyLocalDiscovery.enable = lib.mkEnableOption "Open ports to allow for spotify local discover";
    ssh.enable = lib.mkEnableOption "Enable inbound ssh connections";
    ping.enable = lib.mkEnableOption "Enable pinging";
  };

  config.networking = {
    nftables = {
      enable = true;
      tables = {
        filter = {
          family = "inet";
          content = ''
            # Check out https://wiki.nftables.org/ for better documentation.
            # Table for both IPv4 and IPv6.
            # Block all incoming connections traffic except SSH and "ping".
            chain input {
              type filter hook input priority 0;

              # accept any localhost traffic
              iifname lo accept

              # accept traffic originated from us
              ct state {established, related} accept

              # ICMP
              # routers may also want: mld-listener-query, nd-router-solicit
              ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert } accept
              ip protocol icmp icmp type { destination-unreachable, router-advertisement, time-exceeded, parameter-problem } accept

              ${lib.optionalString cfg.ping.enable ping}
              ${lib.optionalString cfg.spotifyLocalDiscovery.enable spotify}
              ${lib.optionalString cfg.ssh.enable ssh}

              # count and drop any other traffic
              drop
            }

            # Allow all outgoing connections.
            chain output {
              type filter hook output priority 0;
              accept
            }

            chain forward {
              type filter hook forward priority 0;
              accept
            }
          '';
        };
      };
    };
  };
}
