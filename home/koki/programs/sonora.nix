# Sonora music client — module and package come from the `sonora` flake input
# (prebuilt `sonora-bin` on x86_64-linux). Settings are merged into
# ~/.config/sonora/settings.json; keys left out stay app-managed.
{ ... }:
{
  programs.sonora = {
    enable = true;
    settings = { };
  };
}
