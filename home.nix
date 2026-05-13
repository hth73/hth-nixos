{ config, pkgs, ... }:

{
  home.username = "hth";
  home.homeDirectory = "/home/hth";
  home.stateVersion = "25.11";

  # Umgebungsvariablen
  home.sessionVariables = {
    TERM = "xterm-256color";
    LESS = "--RAW-CONTROL-CHARS --LONG-PROMPT --ignore-case";
    GNUPGHOME = "$HOME/.gnupg";
    EDITOR = "vim";
    CDPATH = ".:$HOME:/etc:/var";
  };

  # Zusätzliche PATH-Einträge
  home.sessionPath = [
    "$HOME/bin"
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      h = "history";
      up = "uptime";
      ver = "fastfetch";
      cmount = "mount | column -t";
      av = "freshclam --version";
      cfg = "vim ~/.bashrc";
      d = "dirs -v | head -10";
      vi = "vim";
      ipcalc = "ipcalc --nocolor";
      cat = "bat --plain --paging=never";

      ls = "eza";
      la = "ls -lagoh --git --git-repos";
      ll = "ls -lagoh --total-size --git";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      
      nrs = "sudo nixos-rebuild switch";
      reboot = "sudo reboot";
      shutdown = "sudo shutdown -h now";
      services = "sudo systemctl list-units --type=service --state=running";
      disk = "sudo ncdu";
    };

    bashrcExtra = ''
      # Color manpages
      [[ -f ~/.LESS_TERMCAP ]] && source ~/.LESS_TERMCAP

      # SSH-Agent starten und alle privaten Schlüssel laden
      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)"
        grep -slR "PRIVATE" "$HOME/.ssh/" 2>/dev/null | xargs -r ssh-add
      fi
      
      # Debug Promt
      export PS4=$'|(''${BASH_SOURCE##*/}:''${LINENO}):\t''${FUNCNAME[0]:+''${FUNCNAME[0]}(): }'

      # Funktion: Verzeichnis erstellen und hinein wechseln
      mkcd() {
        mkdir -pv "$1" && cd "$1"
      }
    '';
  };

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

  home.file.".config/qtile".source = /home/hth/.dotfiles/qtile;

  home.file.".config/bat/config".text = ''
    --theme="Catppuccin Mocha"
    --paging=never
    --style=plain
  '';

  home.file.".config/pcmanfm/default/pcmanfm.conf".text = ''
    [config]
    bm_open_method=0

    [volume]
    mount_on_startup=1
    mount_removable=1
    autorun=1

    [ui]
    always_show_tabs=0
    max_tab_chars=32
    win_width=1826
    win_height=911
    splitter_pos=177
    media_in_new_tab=0
    desktop_folder_new_win=0
    change_tab_on_drop=1
    close_on_unmount=1
    focus_previous=0
    side_pane_mode=dirtree
    view_mode=list
    show_hidden=1
    sort=name;ascending;
    columns=name:200;desc;size;mtime:145;
    toolbar=newtab;navigation;home;
    show_statusbar=1
    pathbar_mode_buttons=0
  '';
}  

