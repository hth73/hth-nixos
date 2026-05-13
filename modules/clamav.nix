{ config, pkgs, ... }:

{
  # enable clamav
  services.clamav = {
    daemon = {
      enable = true;
    };
    updater = {
      enable = true;
      frequency = 6;
    };
  };
}
