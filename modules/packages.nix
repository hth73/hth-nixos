{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    btop
    clamav
    clamtk
    curl
    chromium    
    eza
    fastfetch
    fd
    feh
    fzf
    gedit
    git
    gnupg
    iotop
    jq
    lsof
    meld
    neovim
    ncdu
    pcmanfm
    pwgen
    ripgrep
    rofi
    starship
    traceroute
    tree
    unzip
    vim
    vscodium    
    wget
    whois
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
      style = "plain";
    };
  };

  programs.git = {
    enable = true;
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
}
