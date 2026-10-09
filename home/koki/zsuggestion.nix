# zsuggestion user config. The package itself is pkgs/zsuggestion.nix.
{ config, pkgs, ... }:
let
  zsuggestion = pkgs.callPackage ../../pkgs/zsuggestion.nix { };
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
