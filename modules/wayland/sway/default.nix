{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.modules.wayland.sway;
in
{
  imports = [
    ./swayidle.nix
    ./swaylock.nix
  ];

  options.modules.wayland.sway = {
    enable = lib.mkEnableOption "Enable the sway window manager";
    terminal = lib.mkOption {
      type = lib.types.str;

      # Use the global default terminal if chosen. else use the default for sway
      default = options.modules.terminals.default.value;
      apply =
        value: if value != "" then value else options.wayland.windowManager.sway.config.value.terminal;

      description = "Default terminal to use for sway, Overrides the chosend global default";
    };
  };

  config = lib.mkIf cfg.enable {
    # automatically anable wayland if using sway
    modules.wayland.enable = true;

    # Necessary packages that we will need
    # home.packages = with pkgs; [ ];

    wayland.windowManager.sway =
      with pkgs;
      let
        mod = "Mod4";
        left = "h";
        right = "l";
        up = "k";
        down = "j";
      in
      {

        enable = true;
        checkConfig = true;
        wrapperFeatures.gtk = true;

        config = {
          modifier = "${mod}";
          terminal = cfg.terminal;

          fonts = {
            # names = []; # Handeled by stylix
            size = 10.0;
          };

          # Handeled by stylix
          # colors = {};

          # see sway-input(5) for more details
          # There are a lot of options here to check out
          input = {
            "type:touchpad" = {
              #dwt = disable while typing
              dwt = "enabled";
              # I find this annoying. Its just a preference though
              tap = "disable";
              natural_scroll = "enabled";
              middle_emulation = "enabled";
            };
          };

          focus = {
            # Doesn't wrap focus, i.e focus left on left most window doesnt wrap
            # to the right
            # wrapping = false; # default false

            # Don't follow the mouse to change window focus
            # Should still change on click
            followMouse = false;
          };

          gaps = {
            # Size fo the gaps to use between windows in pixels inner = 5;
            outer = 0;
            # This option controls whether to disable container borders on workspace with a single container.
            smartBorders = "on";
            # This option controls whether to disable all gaps (outer and inner) on workspace with a single container.
            smartGaps = true;
          };

          window = {
            border = 3;
            titlebar = false;
            commands = [
              {
                # Zoom doesn't use the fucking notifications API.
                # zooms pop up notifications to be floating by default
                command = "border none, floating enable";
                criteria = {
                  class = "zoom";
                  title = "^zoom$";
                };
              }
              {
                command = "border pixel, floating enable";
                criteria = {
                  class = "zoom";
                  title = "^(Zoom|About)$";
                };
              }
              {
                command = "floating enable, floating_minimum_size 960 x 700";
                criteria = {
                  class = "zoom";
                  title = "Settings";
                };
              }
            ];
          };

          defaultWorkspace = "1";

          assigns = {
            "4" = [
              { app_id = "discord"; }
            ];
            "10" = [
              { app_id = "spotify"; }
            ];
          };

          floating = {
            modifier = "${mod}";
            border = 3;
            titlebar = false;
            criteria = [ ];
          };

          keybindings = lib.mkOptionDefault {
            # rofi: menu
            "${mod}+d" = "exec ${rofi}/bin/rofi -show drun";
            # rofi: bluetooth
            "${mod}+y" = "exec ${rofi-bluetooth}/bin/rofi-bluetooth";
            # rofi: clipboard manager
            # $clipboard set in extraConfigEarly
            "${mod}+p" = "exec $clipboard";

            # rofi: filebrowser
            "${mod}+g" = "exec ${rofi}/bin/rofi -show filebrowser";
            # rofi: emoji
            "${mod}+m" = "exec ${rofimoji}/bin/rofimoji";
            # bpick color
            "${mod}+n" = "exec $networkmanager";
            # mirror screen
            "${mod}+o" = "exec ${wl-mirror}/bin/wl-present mirror";
            # Screenshot
            "${mod}+Shift+s" =
              "exec ${grim}/bin/grim -g \"$(${slurp}/bin/slurp -d)\" - | ${swappy}/bin/swappy -f -";

            # modes
            "${mod}+r" = "mode resize";
            "${mod}+u" = "mode audio";
            "${mod}+x" = "mode session";

            # layout stuff
            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";

            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            # workspaces
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";

            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";

            "${mod}+${left}" = "focus left";
            "${mod}+${down}" = "focus down";
            "${mod}+${up}" = "focus up";
            "${mod}+${right}" = "focus right";

            "${mod}+Shift+${left}" = "move left";
            "${mod}+Shift+${down}" = "move down";
            "${mod}+Shift+${up}" = "move up";
            "${mod}+Shift+${right}" = "move right";

            "${mod}+period" = "workspace next";
            "${mod}+comma" = "workspace prev";

            "${mod}+Shift+period" = "move container to workspace next";
            "${mod}+Shift+comma" = "move container to workspace prev";

            "${mod}+Ctrl+${left}" = "move workspace to output left";
            "${mod}+Ctrl+${down}" = "move workspace to output down";
            "${mod}+Ctrl+${up}" = "move workspace to output up";
            "${mod}+Ctrl+${right}" = "move workspace to output right";

            # audio control
            "XF86AudioRaiseVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
            "XF86AudioLowerVolume" = "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
            "XF86AudioMute" = "exec ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

            # mic control
            "${mod}+XF86AudioRaiseVolume" =
              "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%+";
            "${mod}+XF86AudioLowerVolume" =
              "exec ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 2%-";
            "${mod}+XF86AudioMute" = "exec ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

            # player control
            "XF86AudioPlay" = "exec ${lib.getExe playerctl} play-pause --player=%any,mpv,mpd";
            "XF86AudioPrev" = "exec ${lib.getExe playerctl} previous --player=%any,mpv,mpd";
            "XF86AudioNext" = "exec ${lib.getExe playerctl} next --player=%any,mpv,mpd";
            "XF86AudioStop" = "exec ${lib.getExe playerctl} play-pause --player=%any,mpv,mpd";

            # brightness
            "XF86MonBrightnessUp" = "exec ${lib.getExe light} -A 2";
            "XF86MonBrightnessDown" = "exec ${lib.getExe light} -U 2";
          };

          modes = {
            audio = {
              # audio = "launch: [i]input [o]output";
              Escape = "mode default";
              Return = "mode default";
              "i" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select source, mode default";
              "o" = "exec ${rofi-pulse-select}/bin/rofi-pulse-select sink, mode default";
            };
            resize = {
              Escape = "mode default";
              Return = "mode default";
              "${down}" = "resize grow height 10 px or 10 ppt";
              "${left}" = "resize shrink width 10 px or 10 ppt";
              "${right}" = "resize grow width 10 px or 10 ppt";
              "${up}" = "resize shrink height 10 px or 10 ppt";
            };
            session = {
              # session = launch:
              # [h]ibernate [p]oweroff [r]eboot
              # [s]uspend [l]ockscreen log[o]ut
              Escape = "mode default";
              Return = "mode default";
              "h" = "exec ${systemd}/bin/systemctl hibernate, mode default";
              "p" = "exec ${systemd}/bin/systemctl poweroff, mode default";
              "r" = "exec ${systemd}/bin/systemctl reboot, mode default";
              "s" = "exec ${systemd}/bin/systemctl suspend, mode default";
              "l" = "exec ${lib.getExe swaylock-effects} --daemonize --grace 0, mode default";
              "o" = "exec ${sway}/bin/swaymsg exit, mode default";
            };
          };
        };

        extraConfigEarly = ''
          set $networkmanager ${config.modules.terminals.default} -e nmtui;
          set $clipboard ${cliphist}/bin/cliphist list | ${rofi}/bin/rofi -dmenu | ${cliphist}/bin/cliphist decode | ${wl-clipboard}/bin/wl-copy;

          exec ${lib.getExe light} -N 0.01 
        '';
      };

  };
}
