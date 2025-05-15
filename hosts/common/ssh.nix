{
  lib,
  config,
  ...
}:
let
  cfg = config.hosts.common.ssh;
in
{
  options.hosts.common.ssh = {
    enable = lib.mkEnableOption "Enable an ssh server";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [
        22
        2222
      ];

      settings = {
        PermitRootLogin = "no";
      };

      # Only allow password logins on port 22
      # port 22 is on the local network
      # port 2222 is forwarded and open to the internet
      extraConfig = ''
        			Match LocalPort 22
        				PasswordAuthentication yes

        			Match LocalPort 2222
        				PasswordAuthentication no
                ChallengeResponseAuthentication no
        			'';
    };
  };
}
