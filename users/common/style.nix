{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;

    # see https://github.com/tinted-theming/schemes
    # For more color schemes
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    image = builtins.path {
      path = ../../assets/framework-13-wallpaper.jpeg;
      name = "wallpaper";
    };

    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 18;
    };

    # These fonts seme fine for now, might override them later if I find better fonts
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
