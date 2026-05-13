# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Global Home Manager Settings
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.hth = import ./home.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixus";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
 
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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
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

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    ack
    bat
    btop
    clamav
    clamtk
    curl
    chromium    
    eza
    fastfetch
    feh
    gedit
    git
    gnupg
    iotop
    jq
    lsof
    ncdu
    pcmanfm
    pwgen
    ripgrep
    rofi
    traceroute
    tree
    unzip
    vim
    vscodium    
    wget
    whois
    xclip
    xwallpaper
    yq
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  programs.bat = {
    enable = true;
    settings = {    
      paging = "never";
    };
  };

  programs.git = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

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

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  # enable virtualbox guest
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.clipboard = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.allowedTCPPortRanges = [
  #   {
  #     from = 8999;
  #     to = 9003;
  #    }
  #  ]
  # networking.firewall.allowedUDPPortRanges = [{}]

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11";
}

