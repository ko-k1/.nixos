{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
    };
    initContent = ''
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt HIST_IGNORE_ALL_DUPS
    '';
  };
}
