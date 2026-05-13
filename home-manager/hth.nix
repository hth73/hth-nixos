{ config, pkgs, ... }:

{
  home.username = "hth";
  home.homeDirectory = "/home/hth";
  home.stateVersion = "25.11";

  # Files in Home Folder
  home.file."wallpaper".source = ../dotfiles/hth/wallpaper;
  home.file.".bash_profile".source = ../dotfiles/common/.bash_profile;
  home.file.".bashrc".source = ../dotfiles/hth/.bashrc;
  home.file.".".gitconfigsource = ../dotfiles/hth/.gitconfig;
  home.file.".LESS_TERMCAP".source = ../dotfiles/hth/.LESS_TERMCAP;

  # Config Files User Environment
  home.file.".config/bat".source = ../dotfiles/config/bat;
  home.file.".config/btop".source = ../dotfiles/config/btop;
  home.file.".config/pcmanfm".source = .../dotfiles/config/pcmanfm;
  home.file.".config/qtile".source = .../dotfiles/config/qtile;

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.7;
      font.normal = {
        family = "JetBrains Mono";
        style = "Regular";
      };
    };
  };
}
