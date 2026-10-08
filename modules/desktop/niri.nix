{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config = {
    common = {
      default = [ "gtk" ];
    };
  };

  home-manager.users.koki = {
    xdg.configFile."niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "us"
              }
          }
      }

      prefer-no-csd true

      spawn-at-startup "waybar"

      binds {
          Mod+Return { spawn "kitty"; }
          Mod+Q { close-window; }
          Mod+Shift+E { quit; }
          Mod+F { toggle-window-floating; }
          Mod+Space { switch-focus-between-floating-and-tiling; }
      }
    '';
  };
}
