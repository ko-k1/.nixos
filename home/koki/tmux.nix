{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    historyLimit = 10000;
    prefix = "C-a";
    terminal = "screen-256color";
    sensibleOnTop = true;
    extraConfig = ''
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };
}
