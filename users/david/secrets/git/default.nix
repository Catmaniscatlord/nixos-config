{ ... }:
{
  config = {
    sops.secrets = builtins.listToAttrs (
      map
        (name: {
          name = name;
          value.sopsFile = ./git.yaml;
        })
        [
          "git/userEmail"
          "git/userName"
        ]
    );

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "catmaniscatlord";
          email = "catmanisacatlord@gmail.com";
        };
        safe = {
          directory = "/repos/*";
        };
      };
    };
  };
}
