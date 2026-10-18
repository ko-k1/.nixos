# Lock screen: swaylock-effects with a screenshotted + blurred background,
# big clock/date, and a status ring (Caps Lock, failed attempts, keyboard
# layout). Colours mirror theme.nix (Catppuccin Mocha, blue accent); the
# generated ~/.config/swaylock/config is picked up by a plain `swaylock`
# call from niri/wlogout/hyprland.
{
  pkgs,
  ...
}:
let
  base = "1e1e2e";
  surface1 = "45475a";
  text = "cdd6f4";
  subtext1 = "bac2de";
  blue = "89b4fa";
  mauve = "cba6f7";
  red = "f38ba8";
  yellow = "f9e2af";
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Background: blur a screenshot of the session and vignette the edges;
      # base colour is the fallback when the compositor has no screencopy.
      color = base;
      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;

      # Status: clock + date (redrawn every second), failed attempt count,
      # Caps Lock state, current keyboard layout.
      indicator = true;
      clock = true;
      timestr = "%H:%M";
      datestr = "%A, %d %B";
      font = "FantasqueSansM Nerd Font";
      show-failed-attempts = true;
      show-keyboard-layout = true;
      indicator-caps-lock = true;

      # Indicator geometry: large ring, translucent disc over the blur.
      indicator-radius = 110;
      indicator-thickness = 8;

      # Colours (RRGGBBAA): grey idle ring, blue while typing/verifying,
      # yellow on Caps Lock, red on failure, mauve on cleared.
      inside-color = "${base}99";
      inside-clear-color = "${base}99";
      inside-caps-lock-color = "${base}99";
      inside-ver-color = "${base}99";
      inside-wrong-color = "${base}cc";

      ring-color = surface1;
      ring-clear-color = mauve;
      ring-caps-lock-color = yellow;
      ring-ver-color = blue;
      ring-wrong-color = red;

      key-hl-color = blue;
      bs-hl-color = red;
      caps-lock-key-hl-color = yellow;
      caps-lock-bs-hl-color = yellow;

      text-color = text;
      text-clear-color = mauve;
      text-caps-lock-color = yellow;
      text-ver-color = blue;
      text-wrong-color = red;

      # No dark seams between disc and ring or around highlight segments.
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      separator-color = "00000000";

      # Layout badge under the indicator.
      layout-bg-color = "${base}cc";
      layout-border-color = surface1;
      layout-text-color = subtext1;
    };
  };
}
