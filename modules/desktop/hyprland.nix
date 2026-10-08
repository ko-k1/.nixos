{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config = {
    hyprland = {
      default = [ "hyprland" "gtk" ];
    };
    common = {
      default = [ "gtk" ];
    };
  };

  home-manager.users.koki = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        monitor = [ ", preferred, auto, 1" ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(8ecdc8ee)";
          "col.inactive_border" = "rgba(595959aa)";
        };

        decoration = {
          rounding = 8;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
        };

        "$mod" = "SUPER";

        bind =
          [
            "$mod, Return, exec, kitty"
            "$mod, Q, killactive"
            "$mod, M, exit"
            "$mod, Space, togglefloating"
            "$mod, F, fullscreen"
          ]
          ++ (
            builtins.genList (
              i:
              "$mod, ${
                toString (i + 1)
              }, workspace, ${
                toString (i + 1)
              }"
            ) 9
          );

        exec-once = [ "waybar" ];
      };
    };
  };
}
