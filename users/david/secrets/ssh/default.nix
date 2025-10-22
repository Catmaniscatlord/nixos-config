{
  config,
  ...
}:
{
  config = {
    sops.secrets = builtins.listToAttrs (
      map
        (name: {
          name = name;
          value.sopsFile = ./ssh.yaml;
        })
        [
          "ssh/key"
          "ssh/key.pub"
        ]
    );

    programs.ssh = {
      enable = true;
      extraConfig = ''
        IdentityFile ${config.sops.secrets."ssh/key".path}
        CertificateFile ${config.sops.secrets."ssh/key.pub".path}
      '';
    };
  };
}
