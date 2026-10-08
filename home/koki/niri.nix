# Niri user config (KDL). Enablement is system-side
# (modules/desktop/niri.nix).
{
  config,
  lib,
  pkgs,
  ...
}:
{
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
}
