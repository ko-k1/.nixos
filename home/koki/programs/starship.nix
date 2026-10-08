{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$character";
      directory.truncation_length = 3;
    };
  };
}
