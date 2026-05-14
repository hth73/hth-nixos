{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/openssh.nix
      ./modules/firewall.nix
      ./modules/packages.nix
      ./modules/clamav.nix
      (import "${home-manager}/nixos")
      ./home-manager/common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nixus";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Allow unfree license Pakages
  nixpkgs.config.allowUnfree = true;
 
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Keyboard layout
  console.keyMap = "de";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Keyboard layout, model and optionen for the X-Server (X11) 
  services.xserver.xkb = {
    layout = "de";
    model = "pc105"; # EU/DE-Standard, pc104 = US-Standard
  };

  # Nix garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Automatically optimize nix store and experimental features of the nix package manager
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ 
      "nix-command" 
      "flakes"
    ];
  };

  users.groups.hth = {};
  users.users.hth = {
    isNormalUser = true;
    description = "Helmut Thurnhofer";
    group = "hth";
    extraGroups = [ 
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICn/bnaOdeE/cZaqbDXVP9q96Rj5gs878+9806K0UK2L"
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11";
}
