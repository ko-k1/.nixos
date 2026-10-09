# Writable copies for configs that apps rewrite themselves (zed, VS Code,
# fcitx5, easyeffects, ...). A read-only HM symlink would break their
# in-app settings, so these are real files copied on activation instead.
#
# A file is (re)copied only when its repo source changed since the last
# switch (tracked by store path in $XDG_STATE_HOME/hm-mutable-files), so
# in-app edits survive ordinary switches. When a copy would overwrite
# local changes, the old file is kept as <file>.hm-prev.
#
# Usage: koki.mutableFiles.".config/zed/settings.json" = ./dotfiles/zed/settings.json;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.koki.mutableFiles;
  home = config.home.homeDirectory;
in
{
  options.koki.mutableFiles = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
    description = "Files (relative to $HOME) seeded as writable copies of a source.";
  };

  config = lib.mkIf (cfg != { }) {
    home.activation.kokiMutableFiles = lib.hm.dag.entryAfter [ "linkGeneration" ] (
      ''
        stateDir=${lib.escapeShellArg "${config.xdg.stateHome}/hm-mutable-files"}
        run mkdir -p "$stateDir"

        _kokiSyncMutable() {
          local target="$1" src="$2" stamp="$stateDir/$3"
          if [[ -f "$target" && ! -L "$target" && -f "$stamp" && "$(< "$stamp")" == "$src" ]]; then
            return 0
          fi
          if [[ -e "$target" || -L "$target" ]]; then
            if ! ${pkgs.diffutils}/bin/cmp -s "$src" "$target"; then
              run cp -L "$target" "$target.hm-prev"
            fi
            run rm -f "$target"
          fi
          run install -D -m 0644 "$src" "$target"
          [[ -v DRY_RUN ]] || printf '%s' "$src" > "$stamp"
        }
      ''
      + lib.concatStrings (
        lib.mapAttrsToList (target: source: ''
          _kokiSyncMutable ${lib.escapeShellArg "${home}/${target}"} ${source} ${builtins.hashString "sha256" target}
        '') cfg
      )
    );
  };
}
