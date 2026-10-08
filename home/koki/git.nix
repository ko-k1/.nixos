{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "koki";
      user.email = "koki@example.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      alias = {
        s = "status --short --branch";
        a = "add -A";
        c = "commit";
        d = "diff";
        lg = "log --oneline --graph --decorate";
      };
    };
  };
}
