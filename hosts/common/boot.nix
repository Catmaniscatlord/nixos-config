{
  # use grub as the boot loader. UEFI mdoe only. BIOS is dead.
  # An alternative is systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 10; # only store 10 configurations

      minegrub-theme = {
        enable = true;
        splash = "Flakey";
        background = "background_options/1.20 - [Trails & Tales].png";
        boot-options-count = 4;
      };
    };
  };
}
