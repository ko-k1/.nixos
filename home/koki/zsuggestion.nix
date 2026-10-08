# ko-k1/zsuggestion: nvim-style bordered suggestion popup for Zsh.
# Pinned to an exact commit so upstream pushes don't break builds.
{ config, pkgs, ... }:
let
  zsuggestion = pkgs.rustPlatform.buildRustPackage {
    pname = "zsuggestion";
    version = "unstable-2026-08-21";
    src = pkgs.fetchFromGitHub {
      owner = "ko-k1";
      repo = "zsuggestion";
      rev = "7986216c735850e200a93a88dd12f37775ba3797";
      sha256 = "1f3q4qbqdmzn556kzq7s8fjm864zjr874zn287xh85xp74mzas13";
    };
    cargoLock = {
      lockFile = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ko-k1/zsuggestion/main/Cargo.lock";
        sha256 = "0fbvkvw9mm4s5lbkmiiw40jb4hs93kp5gm3m210h1lv13chmjhvm";
      };
    };
    doCheck = false;
  };
in
{
  home.packages = [ zsuggestion ];

  home.file.".config/zsuggestion/config.toml" = {
    text = ''
      [completion]
      max_candidates = 8
      key = "ctrl-space"
      accept = "full"

      [history]
      ignore_leading_space = true
      successful_first = true

      # Nvim-style menu (borderless since 74bb527)
      [ui]
      menu_width = 64
      max_visible = 6
      prompt_offset = 2
      accent = "14"
      text = "7"
      muted = "8"
      ghost = "8"
      selected_background = "8"
      selected_text = "15"
      selected_source = "0"
    '';
  };
}
