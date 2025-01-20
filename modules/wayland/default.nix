{ lib,
  pkgs,
  config,
  osConfig,
  ... }:
let 
  cfg = config.modules.wayland;
in {
  imports = [
    ./sway
    ./hyperland
    ./rofi.nix
    ./screenshots.nix
  ];

  options.modules.wayland = {
      enable = lib.mkEnableOption "Use wayland protocol";
    };

  config = lib.mkIf (cfg.enable) {

    home.packages = with pkgs; [
      # needed for gtk themeing I believe
      pkgs.dconf

      # clipboard functionality
      wl-clipboard 

      # allow for easy desktop mirroring
      wl-mirror

      # GUI for configuring outputs.
      # Use this for on the fly editing, use kanshi to create default setups
      wlr-layout-ui
      wlr-randr # needed to configure outputs manually
      
      # notification manager developed by swaywm maintainer
      mako 
    ]
      ++ (lib.optional osConfig.hosts.common.sound.enable wireplumber);

    };
}
