# Shells. zsh is the daily driver (zsuggestion owns the suggestion
# ghost-text, so the stock autosuggestion plugin stays off); bash mirrors
# zsh for rescue sessions, fish only gets the shared home.shellAliases.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  # bash/zsh only; the minimal set shared with fish is home.shellAliases.
  posixAliases = {
    c = "clear";
    q = "exit";
    l = "eza -a --colour=always --icons";
    lt = "tree -a -C --dirsfirst";
    nxrb = "sudo nixos-rebuild switch --flake /home/koki/.nixos#h4ck1ng-h0st";
    rebuild = "nix-rebuild";
    check = "nix-check";
    ".." = "cd ..";
    "-" = "cd -";
  };
in
{
  # Applied to bash, zsh and fish alike.
  home.shellAliases = {
    ll = "ls -lah";
    la = "ls -la";
    v = "nvim";
  };

  programs.bash = {
    enable = true;
    shellAliases = posixAliases;
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
    shellAliases = posixAliases;
  };

  programs.fish.enable = true;

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
