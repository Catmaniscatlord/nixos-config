{
  pkgs,
  ...
}:

{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/red/minecraft-servers";

    servers.vanilla = {
      enable = true;

      jvmOpts = "-Xmx4G -Xms2G";

      # Specify the custom minecraft server package
      package = pkgs.paper-server;

      serverProperties = {
        server-port = 25565;
        white-list = true;

        view-distance = 16;
        difficulty = "normal";

        level-seed = 69420029991834373;
        level-name = "fart";

      };
    };
  };
}
