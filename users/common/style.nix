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

    image = pkgs.fetchurl {
      url = "https://static-community.frame.work/original/2X/f/f1ee3ca6ddf6aa3c01e3b50ed3e149ab7e4211c1.jpeg";
      sha256 = "e3e3980717482daa0f4cae2ccf6d7ba60ba3c78be95ffd856971d6980229a7ed";
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
