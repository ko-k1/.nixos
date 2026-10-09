# OpenSSH daemon. Live parity: password auth stays ON because no
# authorized_keys exist yet (~/.ssh has only known_hosts). Flip
# PasswordAuthentication/KbdInteractiveAuthentication back to false AFTER
# adding your public key(s) below — otherwise you lock yourself out of
# remote access on the next switch.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings = {
      # Hardening (opt-in once keys exist):
      # PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
      AllowUsers = [ "koki" ];
    };
  };

  users.users.koki.openssh.authorizedKeys.keys = [
    # "ssh-ed25519 AAAA... koki@h4ck1ng-h0st"
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];
}
