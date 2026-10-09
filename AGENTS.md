# koki's NixOS configuration (v2)

Flake-managed NixOS + Home Manager + devshells + direnv setup.
One-shot apply: `./setup.sh` (see `setup.sh --help`).

## Layout

- `flake.nix`          entrypoint: inputs (nixpkgs 26.05, nixpkgs-unstable, home-manager, shojiwm), nixosConfigurations, homeConfigurations, devShells, overlays, formatter (`nixfmt`)
- `setup.sh`           one-shot bootstrap: preflight → hardware-configuration → one `nixos-rebuild` run
- `hosts/<name>/`      machine entries: `default.nix` (imports modules) + `hardware-configuration.nix`
  - `hosts/common.nix` shared helper for stub hardware configurations (used by desktop, laptop, vm)
- `modules/`           system modules, grouped by concern:
  - `system/` nix (settings+GC), boot, locale, networking, packages, security, users
  - `desktop/` audio, fonts, portal (shared xdg base), ly, hyprland, niri, shojiwm
  - `development/` git, languages (nix-ld), tool (direnv)
  - `hardware/` amd (AMD GPUs only — not imported on h4ck1ng-h0st), nvidia (RTX 2080 Ti, `open=false`, `production` driver)
  - `services/` docker, podman, printing, ollama, sunshine, ssh
  - `programs/` gaming (firefox, steam, wireshark)
- `home/<user>/`       Home Manager modules: `default.nix` + per-concern files
  - `packages.nix` full user package list (`unstable` via extraSpecialArgs)
  - `theme.nix` gtk/qt/cursor/session vars; `shell.nix` bash/zsh/fish/fzf (shared aliases in `home.shellAliases`); `zsuggestion.nix` user config (package in `pkgs/zsuggestion.nix`)
  - `hyprland.nix` / `niri.nix` / `waybar.nix` user-side compositor config (enablement is system-side via `myDesktop.*.enable`)
  - `programs/` per-program modules (kitty, foot, alacritty, wezterm, starship, nvim); starship loads `dotfiles/starship/starship.toml` (Catppuccin Mocha)
  - `programs/nvim/` pure Nix-native LSP setup (`vim.lsp.enable`, servers in `extraPackages`, no Mason)
  - `apps.nix` wires misc app configs from `dotfiles/` (cava, ghostty, fastfetch, rofi, btop, nwg-dock, opencode, kilo, gh, zed, vscode, fcitx5, easyeffects, shojiwm src, mimeapps)
  - `mutable.nix` `koki.mutableFiles` option: writable copies for configs apps rewrite (re-copied only when the repo source changes; overwritten local edits kept as `*.hm-prev`)
  - `dotfiles/` hand-written app configs (incl. `hypr/`, `niri/`, `waybar/`, `starship/`) managed verbatim via `xdg.configFile` or `koki.mutableFiles`; edit here, not in `~/.config`. Store paths are templated (`@btop@`, `@rofi@`), never hard-coded
- `lib/`               flake helpers: `mkSystem`, `mkHome`, `mkPkgs` (single `nixpkgsConfig` incl. `allowUnfree` + insecure allowlist; wires overlays, shojiwm module, `unstable`, `backupFileExtension`)
- `overlays/`          one file per concern (`ly`, `waybar`, `bibata`) composed in `default.nix` + local packages
- `pkgs/`              custom packages (callPackage-able)
  - `pkgs/my-package/` custom package definition (`default.nix`)
  - `pkgs/scripts.nix`  custom scripts: `nix-rebuild`, `nix-check` (as `pkgs.myScripts.*`); `nix-rebuild` owns the repo path (`nxrb` alias calls it)
  - `pkgs/hyprglass.nix`, `pkgs/zsuggestion.nix` pinned third-party builds
- `patches/`           upstream fix patches: ly bigclock color + waybar lua dispatch (via overlays), optional nvidia kernel patch (applied in `modules/hardware/nvidia.nix` to the `production` driver; empty = no-op)
- `devshells/`         per-language dev shells
  - `devshells/common.nix` shared devshell template (base tools + `packages` param)
  - `devshells/all.nix` integrated shell merging every language shell via `inputsFrom` (`nix develop .#all`)

## Commands

- bootstrap:    `./setup.sh` (or `./setup.sh --mode dry|test|boot`)
- rebuild:      `sudo nixos-rebuild switch --flake .#h4ck1ng-h0st`
- dry build:    `sudo nixos-rebuild build --flake .#h4ck1ng-h0st`
- home:         `home-manager switch --flake .#koki`
- check:        `nix flake check`
- shells:       `nix develop` / `nix develop .#all` (everything) (or `. /devshells/...` via direnv)
- format:       `nix fmt`

## Conventions

- Host entry files are always `default.nix`.
- System modules own enablement (`myDesktop.*.enable`, services); home modules own user config. Never write `home-manager.users.*` from `modules/`.
- nvim lives only in `home/koki/programs/nvim/`.
- Fonts live only in `modules/desktop/fonts.nix` (not in `home/koki/packages.nix`).
- nixpkgs config (`allowUnfree`, `permittedInsecurePackages`) lives only in `lib/helpers.nix` `nixpkgsConfig`.
- Only `h4ck1ng-h0st` is wired as a buildable configuration; other hosts are stubs.
- Add a new module: create the file under `modules/`, import it from `hosts/<host>/default.nix`.
- Add a new home module: create the file under `home/koki/`, import it from `home/koki/default.nix`.
- Empty module files should include a `# Placeholder — pending implementation` comment.
- Stub hosts (desktop, laptop, vm) share `hosts/common.nix` for their hardware configuration.
- Devshells share `devshells/common.nix` as a template.
- SSH: password logins are still ON (no authorized keys yet). Add keys in `modules/services/ssh.nix` first, then set `PasswordAuthentication`/`KbdInteractiveAuthentication = false`.
