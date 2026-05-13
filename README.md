# NixOS Test Environment

<img src="https://img.shields.io/badge/VirtualBox-2F61B4?style=flat&logo=virtualbox&labelColor=ffffff&logoColor=2F61B4" /> <img src="https://img.shields.io/badge/NixOS-5277C3?style=flat&logo=nixos&labelColor=ffffff&logoColor=5277C3" />

---

### Inhaltsverzeichnis

* [NixOS Home Manager](home-manager/README.md)
* [NixOS Flakes](...)

---

## Beschreibung

NixOS ist eine auf dem Nix-Paketmanager basierende Linux-Distribution, die auf deklarative Konfiguration und Reproduzierbarkeit setzt. Anstatt das System manuell zu verwalten, wird der gewünschte Zustand wie Benutzer, Dienste, Desktop-Umgebung, Firewall, SSH, Pakete und Locale in der `configuration.nix` beschrieben. Benutzerbezogene Einstellungen wie Shell-Konfigurationen, Git-Settings oder Dotfiles können später mit `Home Manager` ebenfalls deklarativ verwaltet werden.

Ein großer Vorteil von NixOS ist die atomare Aktualisierung des Systems. Jede Änderung erzeugt eine neue Generation, zu der man jederzeit zurückkehren kann. Dadurch sind Rollbacks nach fehlgeschlagenen Änderungen oder Updates jederzeit möglich, was NixOS besonders interessant für reproduzierbare Entwicklungs-, Test- und Serverumgebungen macht.

In dieser Test Umgebungung wird ausschließlich das NixOS Minimal ISO image benutzt.

## VirtualBox VM erstellen

Bei der VirtualBox VM sollte man nur beachten das EFI/UEFI aktiviert wird, die restlichen Einstellungen kann jeder für sich selbst wählen.

- OS: Linux
- OS Version: Other Linux (64-bit)
- ISO Image: ./nixos-minimal-25.xx.....x86_64-linux.iso
- Base Memory: 4096 MB
- EFI/UEFI aktivieren
- Numbers of CPUs: 2
- Video Memory: 128MB
- Storage: 20 - 50 GB
- Network: Bridged Adapter

## Erster Boot mit nixos-minimal-25.xx Live Image

Nachdem das Image gestartet wurde, kann man auch schon loslegen.

```bash
# In den Root Kontext wechseln und das deutsche Tatstatur Layout laden
sudo -i
loadkeys de
```

Hier werden zwei Methoden gezeigt, wie man die Festplatte für eine NixOS Installation einrichten kann.

#### Methode 1 (mit Pre-Boot Authentifizierung und Btrfs Filesystem)

```bash
lsblk # Festplatte Bezeichnung finden

# Erstelle GPT Partition Table
printf "label: gpt\n,512M,U\n,,L\n" | sfdisk /dev/sda

# Filesysteme für EFI Partition anlegen
mkfs.vfat -F 32 -n EFI /dev/sda1

# Luks Verschlüsselung einrichten
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 cryptroot

mkfs.btrfs -L nixos /dev/mapper/cryptroot

# Subvolumes anlegen
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@snapshots

umount /mnt

# Verzeichnisse erneut mounten mit Optionen
mount -o subvol=@root,compress=zstd,noatime /dev/mapper/cryptroot /mnt

mkdir -p /mnt/{boot,home,nix,.snapshots}
ls -la /mnt

mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=@snapshots,compress=zstd,noatime /dev/mapper/cryptroot /mnt/.snapshots

mount /dev/sda1 /mnt/boot

lsblk
# NAME          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
# sda             8:0    0   20G  0 disk  
# ├─sda1          8:1    0  512M  0 part  /boot
# └─sda2          8:2    0 19,5G  0 part  
#   └─cryptroot 254:0    0 19,5G  0 crypt /home
#                                         /.snapshots
#                                         /nix
#                                         /
```

#### Methode 2 (ohne Pre-Boot Authentifizierung und ext4 Filesystem)

```bash
lsblk # Festplatte Bezeichnung finden

# Disk partitionieren
cfdisk /dev/sda

Select label type --> gpt
New --> 1G --> Type --> EFI System
New --> 2G --> Type --> Linux swap
New --> Enter --> Enter --> Rest Linux Filesystem
Write (yes)
Quit

lsblk
# sda
#  sda1  1G # EFI
#  sda2  2G # swap
#  sda3 17G # root

# Disk formatieren
mkfs.fat -F 32 -n boot /dev/sda1
mkswap -L swap /dev/sda2
mkfs.ext4 -L nixos /dev/sda3

# Disk mounten
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2
mount -t efivarfs efivarfs /sys/firmware/efi/efivars

# Mounts überprüfen
lsblk
```

Sollte was nicht funktioniert haben, kann man die Festplatte jederzeit wieder bereinigen und von neuen beginnen.

```bash
# Festplatte bei Bedarf wieder komplett bereinigen
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda

# entfernt letzte Reste (GPT Header etc.)
dd if=/dev/zero of=/dev/sda bs=1M count=100
```

## Default NixOS Configs erzeugen

Nachdem die Festplatte vorbereitet und in das `/mnt` Verzeichnis gemountet wurde, kann man die Default NixOS konfigurationen erzeugen. Diese findet man dann in dem Verzeichnis `/mnt/etc/nixos/`

```bash
nixos-generate-config --root /mnt
```

Meine absolute Basis Konfiguration am Anfang war folgende, um später per SSH auf die Maschine zugreifen zu können. Alles andere wurde dann im zweiten Schritt konfiguriert.

```bash
# Konfigurationsanpassungen für den ersten Boot
vi /mnt/etc/nixos/configuration.nix

# Hostname
networking.hostName = "mynixos";

# Configure network connections interactively with nmcli or nmtui.
networking.networkmanager.enable = true;

# Timezone
time.timeZone = "Europe/Berlin";

# Keyboard layout
console.keyMap = "de";

# Basis Pakete
environment.systemPackages = with pkgs; [
  curl
  vim
  wget
];

# SSH für die erste Anmeldung konfigurieren
services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "yes";
  };
};

# Netzwerk Port Freigabe
networking.firewall.enable = true;
networking.firewall.allowedTCPPorts = [ 22 ];
```
Nachdem die Konfiguration angepasst wurden (siehe [configuration_minimal](https://github.com/hth73/hth-nixos/blob/main/configuration_minimal_v1.txt)), kann alles mit `nixos-install` auf die Festplatte geschrieben werden. Wenn das System fertig installiert wurde fährt man die VM herunter und entfernt das CD Image in der VM.

> [!TIP]<br>
> Das Root Passwort wird am Ende des Installations Prozesses abgefragt.

```bash
## NixOS Konfiguration testen und auf die Festplatte installieren
nix-instantiate --parse /mnt/etc/nixos/configuration.nix
nixos-install
shutdown -h now
```
