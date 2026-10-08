# ly TTY display manager (Catppuccin Mocha theme).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # The kernel VT console collapses every color to its 16-color ANSI
  # palette, so ly stays in 8-color mode. Instead we redefine what those 16
  # colors ARE via vt.default_* params (Catppuccin Mocha pastels). On a
  # 32bpp framebuffer the palette RGB values render in true color.
  boot.kernelParams = [
    "vt.default_red=0x1e,0xf3,0xa6,0xf9,0x89,0xf5,0x8a,0xcd,0x45,0xeb,0xa6,0xf9,0xb4,0xf5,0x89,0xf5"
    "vt.default_grn=0x1e,0x8b,0xe3,0xe2,0xb4,0xc2,0xdf,0xd6,0x47,0xa0,0xe3,0xe2,0xbe,0xc2,0xdc,0xe0"
    "vt.default_blu=0x2e,0xa8,0xa1,0xaf,0xfa,0xe7,0xe8,0xf4,0x5a,0xac,0xa1,0xaf,0xfe,0xe7,0xeb,0xdc"
  ];

  services.displayManager.ly = {
    enable = true;
    settings = {
      full_color = false;
      animation = "colormix";
      animation_timeout_sec = 0;
      # 0x0007 = cyan    -> pastel cyan #8adfe8
      # 0x0005 = blue    -> Catppuccin blue #89b4fa
      # 0x0006 = magenta -> Catppuccin pink #f5c2e7
      colormix_col1 = "0x0007";
      colormix_col2 = "0x0005";
      colormix_col3 = "0x0006";
      bg = "0x0001";
      fg = "0x0008";
      border_fg = "0x0007";
      error_fg = "0x0002";
      # Patched into ly via overlays/ly.nix: big clock color.
      bigclock_fg = "0x0001";
      blank_box = true;
      box_title = "h4ck1ng-h0st";
      asterisk = "0x25CF";
      bigclock = "en";
      bigclock_12hr = false;
      bigclock_seconds = false;
      corner_top_right = "numlock,capslock";
    };
  };
}
