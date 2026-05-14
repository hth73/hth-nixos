# NixOS Home Manager

<img src="https://img.shields.io/badge/VirtualBox-2F61B4?style=flat&logo=virtualbox&labelColor=ffffff&logoColor=2F61B4" /> <img src="https://img.shields.io/badge/NixOS%20Home%20Manager-5277C3?style=flat&logo=nixos&labelColor=ffffff&logoColor=5277C3" />

---

[Back home](../README.md)

---

## Beschreibung

Home Manager erweitert NixOS um die deklarative Verwaltung benutzerspezifischer Konfigurationen. Während `configuration.nix` systemweite Einstellungen wie Dienste, Pakete und Benutzer definiert, verwaltet Home Manager persönliche Dateien und Einstellungen im Home-Verzeichnis.

Dazu gehören unter anderem:<br>
Shell-Konfigurationen (.bashrc, .gitconfig)<br>
Anwendungs-Konfigurationen (~/.config/*)<br>
Benutzerspezifische Pakete (home.packages)<br>
Umgebungsvariablen und Aliase

Alle Konfigurationen werden zentral im Verzeichnis `/etc/nixos` versioniert und bei einem `nixos-rebuild switch` automatisch angewendet. Home Manager erzeugt dabei symbolische Links im Home-Verzeichnis und ermöglicht ebenso wie NixOS ein einfaches Rollback auf frühere Generationen.

<a href="https://nix-community.github.io/home-manager" target="_blank">Home Manager Manual</a>

## Home Manger NixOS Modul

```bash
## https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
## sudo vi configuration.nix

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
```

```bash
# Installiert benutzerspezifische Pakete in das jeweilige Benutzerprofil. 
home-manager.useUserPackages = true;
# Verwendet das gleiche Paketset (pkgs) wie das NixOS-System. 
home-manager.useGlobalPkgs = true;
# Erstellt beim Überschreiben bestehender Dateien eine Sicherung mit der Endung ".backup".
home-manager.backupFileExtension = "backup"; 
# Lädt die Home-Manager-Konfiguration für den Benutzer "hth". 
home-manager.users.hth = import ./home.nix;
```

Bei der Einführung und beim Testen von Home Manager wurden sowohl die `configuration.nix` als auch die `home.nix` zunehmend größer und unübersichtlicher. Daher habe ich mich entschieden, die Konfiguration modular aufzubauen.

Die hier dargestellte Verzeichnisstruktur entstand schrittweise und erforderte mehrere Anpassungen, bis eine übersichtliche und wartbare Lösung gefunden wurde.

Zusätzlich mussten die einzelnen Services und Programme sauber konfiguriert werden, um die endgültigen Konfigurationsdateien zu erzeugen, die in dieser Dokumentation verlinkt werden.

Alle Konfigurationsdateien wie Sie eingesetzt wurden, befinden sich in diesen Repository .

```bash
/etc/nixos
├── configuration.nix
├── dotfiles
│   ├── common
│   │   └── .bash_profile
│   ├── config
│   │   ├── alacritty
│   │   │   ├── dark_pastels
│   │   │   │   └── dark_pastels.toml
│   │   │   └── alacritty.toml
│   │   ├── bat
│   │   │   └── config
│   │   ├── btop
│   │   │   └── btop.conf
│   │   ├── chromium
│   │   │   └── Bookmarks
│   │   ├── pcmanfm
│   │   │   └── default
│   │   │       └── pcmanfm.conf
│   │   └── qtile
│   │       └── config.py
│   └── hth
│       ├── .bashrc
│       ├── .gitconfig
│       ├── .LESS_TERMCAP
│       ├── starship.toml
│       └── wallpaper
│           ├── bench.png
│           └── deer.jpg
├── home-manager
│   ├── common.nix
│   └── hth.nix
├── modules
│   ├── clamav.nix
│   ├── firewall.nix
│   ├── openssh.nix
│   └── packages.nix
└── hardware-configuration.nix
```

Die Konfiguration wurde in mehrere logisch getrennte Module aufgeteilt. Systemweite Einstellungen wie Pakete, Firewall, OpenSSH oder ClamAV befinden sich im Verzeichnis `modules/` und werden zentral in der `configuration.nix` eingebunden. Benutzerspezifische Einstellungen werden über Home Manager im Verzeichnis `home-manager/` verwaltet. Gemeinsam genutzte Konfigurationen liegen in `common.nix`, während individuelle Anpassungen in benutzerspezifischen Dateien wie `hth.nix` definiert werden. Dotfiles und Anwendungs-Konfigurationen werden im Verzeichnis `dotfiles/` versioniert und über Home Manager als symbolische Links in das Home-Verzeichnis eingebunden.

Ziel dieses modularen Aufbaus ist es, die Konfiguration übersichtlich, wartbar und wiederverwendbar zu gestalten. Änderungen können gezielt in einzelnen Modulen vorgenommen werden, ohne dass große zentrale Dateien unübersichtlich werden. Gleichzeitig ermöglicht die Struktur eine einfache Übertragung auf weitere Systeme und Benutzerprofile.

```bash
{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in

{
  imports =
    [ # Include all modules and user configuration
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
      ./modules/openssh.nix
      ./modules/firewall.nix
      ./modules/packages.nix
      ./modules/clamav.nix
      ./home-manager/common.nix
    ];
# ...
```

Alle Konfigurationsdateien oder Moduldateien beginnen mit der gleichen Syntax.

```bash
{ config, pkgs, ... }:

{
  # ...
}
```
