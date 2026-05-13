{ config, pkgs, ... }:

{
  # FIREWALL SECTION
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.allowedUDPPortRanges = [
  #   {
  #     from = 8999;
  #     to = 9003;
  #    }
  #  ];
  # networking.firewall.allowedTCPPortRanges = [
  #   {
  #     from = 1000;
  #     to = 1003;
  #    }
  #  ];
}
