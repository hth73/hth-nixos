# NixOS Flakes

<img src="https://img.shields.io/badge/VirtualBox-2F61B4?style=flat&logo=virtualbox&labelColor=ffffff&logoColor=2F61B4" /> <img src="https://img.shields.io/badge/NixOS%20Flakes-5277C3?style=flat&logo=nixos&labelColor=ffffff&logoColor=5277C3" />

---

[Back home](../README.md)

---

## Beschreibung

Mit Nix Flakes werden alle externen Abhängigkeiten wie `nixpkgs` und `Home Manager` zentral in einer `flake.nix` definiert und in der Datei `flake.lock` auf exakte Commit Stände fixiert. Dadurch wird die gesamte Systemkonfiguration vollständig reproduzierbar und versionskontrolliert.

## Umstellung auf Flakes

Vor der Integration von Flakes wurde das System mit folgendem Befehl upgedatet.

```bash
sudo nixos-rebuild switch --upgrade-all
```

Nach der Integration von `Flake` erfolgt der Build über die in der `flake.nix` definierte Host-Konfiguration. `#mynixos` am Ende des Befehls steht für den lokalen Hostname.

```bash
sudo nixos-rebuild switch --flake /etc/nixos#mynixos
```

## Aufbau der flake.nix

Die Datei `flake.nix` definiert die verwendeten Eingaben (nixpkgs, Home Manager), die unterstützte Host-Konfigurationen, sowie die Module, aus denen das System aufgebaut wird.

Die Datei `flake.lock` speichert die exakten Versionen aller verwendeten Abhängigkeiten und sollte immer zusammen mit der `flake.nix` im Git  Repository versioniert werden.

```bash
{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.mynixos =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
  };
}
```

## Anpassungen an der configuration.nix

Nach der Umstellung auf Flakes werden bisherige fetchTarball-Konstrukte nicht mehr benötigt und können aus der `configuration.nix` entfernt werden.

```bash
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in

(import "${home-manager}/nixos")
```

## Aktualisierung der Abhängigkeiten

Neue Paketstände innerhalb des definierten Release-Zweigs werden mit folgendem Befehl aktualisiert.

```bash
nix flake update
sudo nixos-rebuild switch --flake /etc/nixos#mynixos
```

## Mehrere Hosts verwalten

Mit Flakes können mehrere Systeme innerhalb eines einzigen Repositories definiert werden. Jede Konfiguration erhält einen eigenen Namen und kann gezielt aufgebaut werden.

```bash
sudo nixos-rebuild switch --flake /etc/nixos#web01
sudo nixos-rebuild switch --flake /etc/nixos#db01
```

### Mögliche Verzeichnisstruktur

```bash
/etc/nixos/
├── flake.nix
├── configuration.nix
├── hosts/
│   ├── web01/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── db01/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── app01/
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/
├── roles/
├── home-manager/
└── dotfiles/
```

- `configuration.nix` enthält die gemeinsame Basis.
- `hardware-configuration.nix` enthält die lokale Hardware Konfiguration des jeweiligen Servers.
- `hosts/` enthält hostspezifische Einstellungen wie Hostname und Rollen.
- `roles/` enthält wiederverwendbare Serverrollen wie Docker, Nginx oder PostgreSQL.
- `modules/` enthält allgemeine Systemmodule.
- `home-manager/` enthält benutzerspezifische Konfigurationen.
- `dotfiles/` enthält versionierte Konfigurationsdateien.

### Host Konfiguration

```bash
# hosts/web01/default.nix
{
  imports = [
    ./hardware-configuration.nix
    ../../roles/nginx.nix
    ../../roles/docker.nix
  ];

  networking.hostName = "web01";
}
```

### Flake Konfiguration

```bash
nixosConfigurations = {
  web01 = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      ./hosts/web01
    ];
  };

  db01 = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      ./hosts/db01
    ];
  };
};
```

Auf einer neuen Maschine wird die passende `hardware-configuration.nix` mit folgendem Befehl erstellt.

```bash
sudo nixos-generate-config --show-hardware-config > /etc/nixos/hosts/web01/hardware-configuration.nix
```
