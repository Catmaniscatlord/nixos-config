{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.wayland;
in
{
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = cfg.enable;
      # package = pkgs.-wayland;

      plugins = with pkgs; [ ];

      extraConfig = {
        case-sensitive = false;
        display-drun = "Apps";
        display-run = "Run";
        display-file-browser = "Files";
        display-window = "Window";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";

        modi = [
          "drun"
          "run"
          "filebrowser"
          "window"
        ];
      };

      # Theme stolen from https://github.com/adi1090x/rofi/blob/master/files/launchers/type-6/style-1.rasi
      theme =
        let
          mkLiteral = config.lib.formats.rasi.mkLiteral;
          style = config.stylix;
        in
        {
          /**
            ***----- Main Window -----****
          */
          "window" = {
            # properties for window widget
            transparency = "real";
            location = mkLiteral "center";
            anchor = mkLiteral "center";
            fullscreen = mkLiteral "false";
            width = mkLiteral "1000px";
            x-offset = mkLiteral "0px";
            y-offset = mkLiteral "0px";

            # properties for all widgets
            enabled = mkLiteral "true";
            border-radius = mkLiteral "15px";
            cursor = "default";
            background-color = mkLiteral "@background";
          };

          /**
            ***----- Main Box -----****
          */
          "mainbox" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "0px";
            background-color = mkLiteral "transparent";
            orientation = mkLiteral "horizontal";
            children = mkLiteral "[ imagebox, listbox ]";
          };

          "imagebox" = {
            padding = mkLiteral "20px";
            background-color = mkLiteral "transparent";
            background-image = mkLiteral "url(\"${style.image}\", height)";
            orientation = mkLiteral "vertical";
            children = mkLiteral "[ inputbar, dummy, mode-switcher ]";
          };

          "listbox" = {
            spacing = mkLiteral "20px";
            padding = mkLiteral "20px";
            background-color = mkLiteral "transparent";
            orientation = mkLiteral "vertical";
            children = mkLiteral "[ message, listview ]";
          };

          "dummy" = {
            background-color = mkLiteral "transparent";
          };

          /**
            ***----- Inputbar -----****
          */
          "inputbar" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "10px";
            padding = mkLiteral "15px";
            border-radius = mkLiteral "10px";
            background-color = mkLiteral "@alternate-normal-background";
            # text-color = mkLiteral "@foreground";
            children = mkLiteral "[ textbox-prompt-colon, entry ]";
          };
          "textbox-prompt-colon" = {
            enabled = mkLiteral "true";
            expand = mkLiteral "false";
            str = "";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "entry" = {
            enabled = mkLiteral "true";
            background-color = mkLiteral "inherit";
            text-color = lib.mkDefault (mkLiteral "inherit");
            cursor = mkLiteral "text";
            placeholder = "Search";
            placeholder-color = mkLiteral "inherit";
          };

          /**
            ***----- Mode Switcher -----****
          */
          "mode-switcher" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "20px";
            background-color = mkLiteral "transparent";
            # text-color = mkLiteral "@foreground";
          };
          "button" = {
            padding = mkLiteral "15px";
            border-radius = mkLiteral "10px";
            background-color = mkLiteral "@alternate-normal-background";
            text-color = lib.mkDefault (mkLiteral "inherit");
            cursor = mkLiteral "pointer";
          };
          "button selected" = {
            background-color = mkLiteral "@selected-normal-background";
            # text-color = mkLiteral "@foreground";
          };

          /**
            ***----- Listview -----****
          */
          "listview" = {
            enabled = mkLiteral "true";
            columns = mkLiteral "1";
            lines = mkLiteral "8";
            cycle = mkLiteral "true";
            dynamic = mkLiteral "true";
            scrollbar = mkLiteral "false";
            layout = mkLiteral "vertical";
            reverse = mkLiteral "false";
            fixed-height = mkLiteral "true";
            fixed-columns = mkLiteral "true";

            spacing = mkLiteral "10px";
            background-color = mkLiteral "transparent";
            # text-color = mkLiteral "@foreground";
            cursor = "default";
          };

          /**
            ***----- Elements -----****
          */
          "element" = {
            enabled = mkLiteral "true";
            spacing = mkLiteral "15px";
            padding = mkLiteral "8px";
            border-radius = mkLiteral "10px";
            background-color = mkLiteral "transparent";
            # text-color = mkLiteral "@foreground";
            cursor = mkLiteral "pointer";
          };
          # element normal."normal" = {
          #     background-color = mkLiteral "inherit";
          #     text-color = mkLiteral "inherit";
          # };
          # element normal."urgent" = {
          #     background-color = mkLiteral "@urgent";
          #     text-color = mkLiteral "@foreground";
          # };
          # element normal."active" = {
          #     background-color = mkLiteral "@active";
          #     text-color = mkLiteral "@foreground";
          # };
          # element selected."normal" = {
          #     background-color = mkLiteral "@selected";
          #     text-color = mkLiteral "@foreground";
          # };
          # element selected."urgent" = {
          #     background-color = mkLiteral "@urgent";
          #     text-color = mkLiteral "@foreground";
          # };
          # element selected."active" = {
          #     background-color = mkLiteral "@urgent";
          #     text-color = mkLiteral "@foreground";
          # };
          "element-icon" = {
            background-color = lib.mkDefault (mkLiteral "transparent");
            text-color = mkLiteral "inherit";
            size = mkLiteral "32px";
            cursor = mkLiteral "inherit";
          };
          "element-text" = {
            background-color = lib.mkDefault (mkLiteral "transparent");
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };

          /**
            ***----- Message -----****
          */
          "message" = {
            background-color = mkLiteral "transparent";
          };
          "textbox" = {
            padding = mkLiteral "15px";
            border-radius = mkLiteral "10px";
            background-color = mkLiteral "@alternate-normal-background";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };
          "error-message" = {
            padding = mkLiteral "15px";
            border-radius = mkLiteral "20px";
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
          };
        };

    };
  };
}
