{ config, pkgs, ... }:

{
  # Global Home Manager Settings
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.hth = import ./hth.nix;
}
