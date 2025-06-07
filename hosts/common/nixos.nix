{
  # Behaviors For NixOs
  system = {
    stateVersion = "25.05"; # Current version of NixOS

    copySystemConfiguration = false; # With flakes this only copies the first file ...

    # Automatic upgrades to Nix, Whats the worst that could happen?
    autoUpgrade = {
      enable = true;
      allowReboot = false; # Automatic reboots can burn in hell
    };
  };
}
