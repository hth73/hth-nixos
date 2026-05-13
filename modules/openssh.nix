{ config, pkgs, ... }:

{
  # Enable the ssh service with ssh hardening
  services.openssh = {
    enable = true;
    settings = {
      # =========================
      # Authentication
      # =========================
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      ChallengeResponseAuthentication = false;
      AuthenticationMethods = "publickey";
      UsePAM = true;

      # =========================
      # Features
      # =========================
      X11Forwarding = false;
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      PermitTunnel = false;
      Compression = false;

      # =========================
      # Limits
      # =========================
      LoginGraceTime = 30;
      MaxAuthTries = 3;
      MaxSessions = 2;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;

      # =========================
      # Crypto
      # =========================
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
      ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
      ];

      # =========================
      # DHEat Mitigation
      # =========================
      MaxStartups = "10:30:60";
      PerSourceMaxStartups = 2;
      PerSourceNetBlockSize = "32:128";
    };
  };
}
