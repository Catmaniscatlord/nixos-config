# Follows the layout for home-manager.service.kanshi.profiles
# see swaymsg -t get_outputs
let
  laptop = {
    # Name of the monitor, or output port
    criteria = "BOE 0x095F Unknown";
    mode = "2256x1504";
    position = "0,0";
    scale = 1.5;
    transform = "normal";
  };
in
{
  output = [
    {
      profile = {
        name = "default";

        outputs = [
          laptop
        ];
      };
    }

    {
      profile = {
        name = "office";
        outputs = [
          laptop
          {
            # Name of the monitor, or output port
            criteria = "Sceptre Tech Inc Sceptre Q27 0x00000001";
            mode = "2560x1440";
            position = "1504,0";
            scale = 1.0;
            transform = "normal";
          }
          {
            # Name of the monitor, or output port
            criteria = "DP-3 Sceptre Tech Inc Sceptre Q27 0x00000001";
            mode = "2560x1440";
            position = "2948,0";
            scale = 1.0;
            transform = "normal";
          }
        ];
      };
    }

  ];
}
