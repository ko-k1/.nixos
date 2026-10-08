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

  networking.firewall.allowedTCPPorts = [ 22 ];
}
