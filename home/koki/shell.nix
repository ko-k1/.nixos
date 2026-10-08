# Shells. zsh is the daily driver (zsuggestion owns the suggestion
# ghost-text, so the stock autosuggestion plugin stays off); bash/fish are
# configured with the same aliases for rescue sessions.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  aliases = {
    ll = "ls -lah";
    v = "nvim";
    c = "clear";
    q = "exit";
    l = "eza -a --colour=always --icons";
    lt = "tree -a -C --dirsfirst";
    nxrb = "sudo nixos-rebuild switch --flake .";
    rebuild = "nix-rebuild";
    check = "nix-check";
    ".." = "cd ..";
    "-" = "cd -";
  };
  fishAliases = {
    ll = "ls -lah";
    v = "nvim";
  };
in
{
  home.shellAliases = {
    ll = "ls -lah";
    la = "ls -la";
  };

  programs.bash = {
    enable = true;
    shellAliases = aliases;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # zsuggestion owns ZLE's suggestion/ghost-text display; a second
    # autosuggestion plugin would conflict with it.
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
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
      eval "$(zsuggestion init zsh)"
    '';
    shellAliases = aliases;
  };

  programs.fish = {
    enable = true;
    shellAliases = fishAliases;
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height=10"
      "--popup=bottom,50%,12"
      "--border=sharp"
      "--no-info"
    ];
  };
}
