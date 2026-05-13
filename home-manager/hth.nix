{ config, pkgs, ... }:

{
  home.username = "hth";
  home.homeDirectory = "/home/hth";
  home.stateVersion = "25.11";

  home.file.".".source = ../dotfiles/common/.bash_profile;
  home.file.".".source = ../dotfiles/common/.bashrc;
  home.file.".".source = ../dotfiles/common/.gitconfig;
  home.file.".".source = ../dotfiles/common/.LESS_TERMCAP;

  home.file."./wallpaper".source = ../dotfiles/hth/wallpaper;
  home.file.".config/bat".source = ../dotfiles/common/bat;
  home.file.".config/btop".source = ../dotfiles/common/btop;
  home.file.".config/pcmanfm".source = .../dotfiles/common/pcmanfm;
  home.file.".config/qtile".source = .../dotfiles/common/qtile;

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
