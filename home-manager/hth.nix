{ config, pkgs, ... }:

{
  home.username = "hth";
  home.homeDirectory = "/home/hth";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    age
    cht-sh
    # fluxcd
    # helm
    # k3d
    # k9s
    # kubectl
    # kustomize
    # packer
    sops
    # terraform
    # vagrant
  ];

  # Files in Home Folder
  home.file."wallpaper".source = ../dotfiles/hth/wallpaper;
  home.file.".bash_profile".source = ../dotfiles/common/.bash_profile;
  home.file.".bashrc".source = ../dotfiles/hth/.bashrc;
  home.file.".gitconfig".source = ../dotfiles/hth/.gitconfig;
  home.file.".LESS_TERMCAP".source = ../dotfiles/hth/.LESS_TERMCAP;
  home.file.".config/starship.toml".source = ../dotfiles/hth/starship.toml;
  home.file.".config/chromium/Default/Bookmarks".source = ../dotfiles/config/chromium/Bookmarks;

  # Config Files User Environment
  home.file.".config/alacritty".source = ../dotfiles/config/alacritty;
  home.file.".config/bat".source = ../dotfiles/config/bat;
  home.file.".config/btop".source = ../dotfiles/config/btop;
  home.file.".config/pcmanfm".source = ../dotfiles/config/pcmanfm;
  home.file.".config/qtile".source = ../dotfiles/config/qtile;

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
