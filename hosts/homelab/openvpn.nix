{
  lib,
  pkgs,
  config,
  ...
}:
let
  filePath = /etc/nixos/hosts/homelab/public-ip.txt;
  public_ip = lib.strings.trim (builtins.readFile filePath);

  vpnPort = 1194;
  vpnIf = "tun0";
  vpnSubnet = "10.8.0.0";
  vpnServerIp = "10.8.0.1";

  pkiDir = "/var/lib/openvpn/pki";
  ccdDir = "/var/lib/openvpn/ccd";
  clientsDir = "/var/lib/openvpn/clients";
  easyRSA = "${pkgs.easyrsa}/bin/easyrsa";
in
{
  options.services.openvpn.clients = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule ({
        options = {
          ip = lib.mkOption {
            type = lib.types.str;
            description = "Static IP assigned to this client.";
          };
          forceRegenerate = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "If true, reissue client cert and regenerate profile on rebuild.";
          };
        };
      })
    );
    default = { };
    description = "Declarative OpenVPN clients with optional forced regeneration.";
  };

  config = {

    environment.systemPackages = [
      pkgs.easyrsa
    ];

    services.openvpn = {

      clients = {
        panther.ip = "10.8.0.2";
        cat.ip = "10.8.0.3";
      };

      servers = {
        cum = {
          config = ''
            # Certificates and keys
            ca ${pkiDir}/pki/ca.crt
            cert ${pkiDir}/pki/issued/server.crt
            key ${pkiDir}/pki/private/server.key
            dh ${pkiDir}/pki/dh.pem

            tls-crypt ${pkiDir}/ta.key
            # crl-verify ${pkiDir}/pki/crl.pem

            cipher AES-256-GCM
            auth SHA256

            port ${toString vpnPort}
            proto udp

            server ${vpnSubnet} 255.255.255.0

            dev ${vpnIf}

            # Use a subnet for clients
            client-to-client
            topology subnet

            ccd-exclusive
            client-config-dir ${ccdDir}

            ifconfig-pool-persist /var/lib/openvpn/ipp.txt

            # Push routes to clients
            push "dhcp-option DNS ${vpnServerIp}"

            keepalive 10 120
            persist-key
            persist-tun
          '';

          autoStart = true;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${pkiDir} 0700 root root -"
      "d ${ccdDir} 0750 root root -"
      "d ${clientsDir} 0750 root root -"
    ];

    systemd.services.openvpn-generate = {
      description = "Generate OpenVPN PKI, clients, and profiles declaratively";
      before = [ "openvpn-cum.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Environment = "PATH=${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.easyrsa}/bin:/run/current-system/sw/bin";
      };

      script = lib.concatStringsSep "\n" (
        [
          ''
            mkdir -p ${pkiDir} ${ccdDir} ${clientsDir}
            cd ${pkiDir}

            # --- PKI Setup ---
            if [ ! -f "pki/ca.crt" ]; then
              echo "[PKI] Initializing..."
              ${easyRSA} init-pki
              ${easyRSA} --batch build-ca nopass
              ${easyRSA} gen-dh
              ${easyRSA} --batch build-server-full server nopass
              ${easyRSA} gen-crl
              openvpn --genkey secret ta.key
              echo "[PKI] Initialized."
            else
              echo "[PKI] Already exists — skipping."
            fi
          ''
        ]
        ++ lib.mapAttrsToList (name: client: ''
          echo "[Client] Processing ${name}..."

          if ${lib.boolToString client.forceRegenerate}; then
            echo "[Client] Force regenerate enabled — removing old certs and configs."
            rm -f pki/issued/${name}.crt pki/private/${name}.key ${clientsDir}/${name}.ovpn ${ccdDir}/${name}
          fi

          if [ ! -f "pki/issued/${name}.crt" ]; then
            ${easyRSA} --batch build-client-full ${name} nopass
            echo "ifconfig-push ${client.ip} 255.255.255.0" > ${ccdDir}/${name}

            output="${clientsDir}/${name}.ovpn"
            # Header
            printf 'client\n' >> "$output"
            printf 'dev ${vpnIf}\n' >> "$output"
            printf 'proto udp\n' >> "$output"
            printf 'remote ${public_ip} ${toString vpnPort}\n' >> "$output"
            printf 'nobind\n' >> "$output"
            printf 'persist-key\n' >> "$output"
            printf 'persist-tun\n' >> "$output"
            printf 'remote-cert-tls server\n' >> "$output"
            printf 'cipher AES-256-GCM\n' >> "$output"
            printf 'auth SHA256\n' >> "$output"
            printf 'topology subnet\n' >> "$output"
            printf 'verb 3\n' >> "$output"

            # Certificates and keys
            printf '<ca>\n' >> "$output"
            cat "${pkiDir}/pki/ca.crt" >> "$output"
            printf '</ca>\n' >> "$output"

            printf '<cert>\n' >> "$output"
            cat "${pkiDir}/pki/issued/${name}.crt" >> "$output"
            printf '</cert>\n' >> "$output"

            printf '<key>\n' >> "$output"
            cat "${pkiDir}/pki/private/${name}.key" >> "$output"
            printf '</key>\n' >> "$output"

            printf '<tls-crypt>\n' >> "$output"
            cat "${pkiDir}/ta.key" >> "$output"
            printf '</tls-crypt>\n' >> "$output"
          fi
        '') config.services.openvpn.clients
      );
    };

  };
}
