# OpenSSH daemon. Password/KBD logins are off: add your public key(s)
# below (or via secrets/) before relying on remote access, otherwise you
# lock yourself out.
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
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
      AllowUsers = [ "koki" ];
    };
  };

  users.users.koki.openssh.authorizedKeys.keys = [
    # "ssh-ed25519 AAAA... koki@h4ck1ng-h0st"
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];
}
