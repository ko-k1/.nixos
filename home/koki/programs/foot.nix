# foot terminal: stock config, enabled via programs.foot so HM owns
# foot.ini.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.foot.enable = true;
}
