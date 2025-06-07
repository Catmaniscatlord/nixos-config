{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.terminals.kitty;
in
{

  options.modules.terminals.kitty = {
    enable = lib.mkEnableOption "Use the kitty terminal";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      nerd-fonts.symbols-only
    ];

    programs.kitty = lib.mkForce {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        enable_audio_bell = false;
        mouse_hide_wait = "-1.0";
        window_padding_width = 10;
        background_opacity = "0.5";
        background_blur = 5;
        # Mappings from https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
        symbol_map =
          let
            mappings = [
              "U+23fb-U+23fe"
              "U+2665"
              "U+26a1"
              "U+2b58"
              "U+e000-U+e00a"
              "U+e0a0-U+e0a2"
              "U+e0a3"
              "U+e0b0-U+e0b3"
              "U+e0b4-U+e0c8"
              "U+e0ca"
              "U+e0cc-U+e0d7"
              "U+e200-U+e2a9"
              "U+e300-U+e3e3"
              "U+e5fa-U+e6b7"
              "U+e700-U+e8ef"
              "U+ea60-U+ec1e"
              "U+ed00-U+efce"
              "U+f000-U+f2ff"
              "U+f300-U+f381"
              "U+f400-U+f533"
              "U+f500-U+fd46"
              "U+f0001-U+f1af0"
            ];
          in
          (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      };
    };
  };
}
