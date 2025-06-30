# Follows the layout for home-manager.service.kanshi.profiles
# see swaymsg -t get_outputs
{
  profile.name = "default";

  profile.outputs = [
    {
      # Name of the monitor, or output port
      criteria = "BOE 0x095F Unknown";
      mode = "2256x1504 @ 59.999";
      position = "0,0";
      scale = 1.5;
      transform = "normal";
    }
  ];
}
