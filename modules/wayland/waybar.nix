{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.wayland;
in
{
  config = lib.mkIf cfg.enable {

    # can be left enabled if we are using sway or not
    wayland.windowManager.sway.config.bars = [
      {
        command = "${pkgs.waybar}/bin/waybar";
      }
    ];

    # Stylix's config for waybar kinda sucks
    # Date 01/01/25
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;

      settings =
        let
          endLeftWrap = name: name ++ [ "custom/r-arr-c" ];
          endRightWrap = name: [ "custom/l-arr-c" ] ++ name;
          leftWrap = name: [ "custom/r-arr-o" ] ++ name ++ [ "custom/r-arr-c" ];
          rightWrap = name: [ "custom/l-arr-c" ] ++ name ++ [ "custom/l-arr-o" ];
          centerWrap = name: [ "custom/l-arr-c" ] ++ name ++ [ "custom/r-arr-c" ];
        in
        [
          {
            layer = "top";
            position = "top";

            "group/group-network" = {
              orientation = "inherit";
              modules = (rightWrap [ "network" ]);
            };

            "group/group-clipboard" = {
              orientation = "inherit";
              modules = (leftWrap [ "custom/clipboard" ]);
            };

            "group/group-audio" = {
              orientation = "inherit";
              modules = (rightWrap [ "pulseaudio" ]);
            };

            "group/group-idle-inhibitor" = {
              orientation = "inherit";
              modules = (endRightWrap [ "idle_inhibitor" ]);
            };

            modules-left =
              if cfg.sway.enable then (endLeftWrap [ "sway/workspaces" ]) ++ (leftWrap [ "sway/mode" ]) else [ ];

            modules-center =
              (rightWrap [ "tray" ])
              ++ (rightWrap [ "clock#2" ])
              ++ (centerWrap [ "clock#1" ])
              ++ [ "group/group-clipboard" ]
              ++ (leftWrap [
                "temperature"
                "cpu"
              ]);

            modules-right =
              [ "group/group-network" ]
              ++ [ "group/group-audio" ]
              ++ (rightWrap [ "backlight" ])
              ++ (rightWrap [ "battery" ])
              ++ [ "group/group-idle-inhibitor" ];

            # Sway specific
            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              on-click = "activate";
              format = "{name} {windows}";
              disable-markup = true;
              window-rewrite-default = "{name}";
              window-format = "{name}";
              window-rewrite = {
                "class<google-chrome>" = "󰊯";
                "class<firefox>" = "";
                "class<discord>" = "";
                "class<spotify>" = "󰓇";
                "class<kitty>" = "";
                # sway supports regex matching. (pretty neat)
                "class<org.pwmt.zathura>" = "";
                "class<sioyek>" = "";
                "class<org.prismlauncher.PrismLauncher>" = "";
                # no zoom icon, so fuck it well use skypes
                "class<zoom>" = "";
                "class<^Steam$>" = "";
                # TODO fix this shit
                # "[Mm]inecraft.*" = "󰍳";
              };
              sort-by-number = true;
            };

            "sway/mode" = {
              hide-empty-text = true;
              format = "{}";
              tooltip = false;
            };

            # General
            "clock#1" = {
              format = "{:%H:%M}";
              tooltip = false;
            };

            "clock#2" = {
              format = "{:%m-%d-%y}";
              tooltip = false;
            };

            backlight = {
              format = "{icon}  {percent}%";
              format-icons = [
                "󰛩"
                "󱩏"
                "󱩑"
                "󱩓"
                "󱩕"
                "󰛨"
              ];
              tooltip = false;
            };

            battery = {
              interval = 10;
              states = {
                warning = 30;
                critical = 15;
              };
              format-time = "{H}:{M:02}";
              format = "{icon} {capacity}%";
              format-charging = "{icon}󱐋 {capacity}%";
              format-charging-full = "󱐋";
              format-full = "󰁹{icon}";
              format-alt = "{icon} {power}W";
              format-icons = [
                "󰂎"
                "󰁻"
                "󰁽"
                "󰁿"
                "󰂁"
                "󰁹"
              ];
              tooltip-format = "{timeTo}";
            };

            cpu = {
              format = " {usage}%";
              states = {
                warning = 75;
                critial = 90;
              };
            };

            disk = {
              format = "󰋊 {free}";
              tooltip-format = "used {used} total {total}";
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = [ " " ];
                deactivated = [ " " ];
              };
              tooltip-format = "idle inhibitor";
            };

            network = {
              format = "{ifname}";
              format-wifi = "{icon} {essid}";
              format-alt = "{ipaddr} {icon}";
              format-alt-click = "click-right";
              format-icons = {
                wifi = [
                  "󰤯"
                  "󰤟"
                  "󰤢"
                  "󰤥"
                  "󰤨"
                ];
                ethernet = [ "󰈁" ];
                disconnected = [ "" ];
              };
              on-click = "swaymsg -q exec '$networkmanager'";
              tooltip-format = "{ipaddr}/{cidr}";
            };

            memory = {
              format = "󰍛 {avail} GiB";
              tooltip-format = "total {total}GiB";
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-bluetooth = "󰂯 {icon} {volume}%";
              format-muted = "󰝟";
              format-icons = {
                headphone = "";
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
              };
              scroll-step = 1;
              on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              tooltip-format = "{desc}";
            };

            tray = {
              format = "{}";
              spacing = 10;
            };

            temperature = {
              format = "{icon}{temperatureC}°C";
              critical-threshold = 80;
              # Thermal zone 0 on the framework-13 is BS (only displays 20)
              # if this is different on different machines idk
              thermal-zone = 1;
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
              tooltip = false;
            };

            # custom Modules
            "custom/clipboard" = {
              format = "󰅍";
              on-click = "swaymsg -q exec '$clipboard'";
              tooltip = false;
            };

            "custom/l-arr-c" = {
              format = "";
              tooltip = false;
            };
            "custom/l-arr-o" = {
              format = "";
              tooltip = false;
            };
            "custom/r-arr-c" = {
              format = "";
              tooltip = false;
            };
            "custom/r-arr-o" = {
              format = "";
              tooltip = false;
            };
          }
        ];

      style =
        with config.stylix;
        with config.lib.stylix.colors.withHashtag;
        ''
          @define-color background ${base00}; @define-color background-alt ${base01};
          @define-color background-select ${base02};
          @define-color selected ${base0D};
          @define-color text-color ${base05}; @define-color text-color-alt ${base04};
          @define-color warning ${base0A}; @define-color urgent ${base09};
          @define-color error ${base08};
          * {
            /* Reset all styles */
            border: none;
            border-radius: 0;
            min-height: 0;
            margin: 0;
            padding: 0;
            box-shadow: none;
            text-shadow: none;
            -gtk-icon-shadow: none;

            /* Custom styling */
            font-family: "${fonts.monospace.name}";
            font-size: ${builtins.toString fonts.sizes.desktop}pt;
            transition: all 0.5s ease;
          }

          window#waybar {
            background: alpha(@background, ${builtins.toString opacity.desktop});
            color: @text-color;
          }

          /* All Modules */
          #battery,
          #backlight,
          #clock,
          #cpu,
          #custom-clipboard,
          #disk,
          #mode,
          #memory,
          #network,
          #pulseaudio,
          #tray,
          #temperature,
          #idle_inhibitor,
          #workspaces button {
            background: @background-select;
            padding-left: 4pt;
            padding-right: 4pt;
          }

          /* HOVERS */
          /* tooltipable */

          #backlight:hover,
          #battery:hover,
          #network:hover,
          #pulseaudio:hover
          #custom-clipboard:hover,
          #cpu:hover,
          #workspaces button:hover {
            text-shadow: 2px 2px 2px @text-color-alt;
          }

          /* clickable */
          #group-clipboard:hover > * > *,
          #group-network:hover > * > *,
          #group-audio:hover > * > *,
          #group-idle-inhibitor:hover > * > *,
          #workspaces button:hover {
            background: @background-alt;
          }

          /* Warning */
          #battery.warning,
          #cpu.warning,
          #workspaces button.urgent, 
          #mode {
            color: @urgent;
          }

          /* Critical */
          #battery.critical,
          #cpu.critical,
          #idle_inhibitor.activated,
          #temperature.critical {
            color: @error;
          }

          /* Workspace stuff*/
          #workspaces { 
            padding: 0 0pt;
          }

          #workspaces button {
            padding-left: 4pt;
            padding-right: 8pt;
            border-left: 2pt solid @background-select;
            border-right: 2pt solid @background-select;
            /* declare twice because css confuses me at times */
            transition: all 0.5s ease, color 0.01s linear;
          }

          #workspaces button.focused {
            color: @selected;
            /* declare twice because css confuses me at times */
            transition: all 0.5s ease, color 0.01s linear;
          }

          /* Custom arrow */
          #custom-r-arr-c,
          #custom-l-arr-c,
          #custom-r-arr-o,
          #custom-l-arr-o  {
            color: @background;
            background: @background-select;
          }
        '';
    };
  };
}
