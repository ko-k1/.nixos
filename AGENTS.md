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
  - `hardware/` amd, nvidia (RTX 2080 Ti, `open=false`, stable pinned to kernel)
  - `services/` docker, podman, printing, ollama, sunshine, ssh
  - `programs/` gaming (firefox, steam, wireshark)
- `home/<user>/`       Home Manager modules: `default.nix` + per-concern files
  - `packages.nix` full user package list (`unstable` via extraSpecialArgs)
  - `theme.nix` gtk/qt/cursor/session vars; `shell.nix` bash/zsh/fish/fzf; `zsuggestion.nix` pinned rust build
  - `hyprland.nix` / `niri.nix` / `waybar.nix` user-side compositor config (enablement is system-side via `myDesktop.*.enable`)
  - `starship.toml` Catppuccin Mocha prompt (loaded by `programs/starship.nix`)
  - `programs/nvim/` pure Nix-native LSP setup (`vim.lsp.enable`, servers in `extraPackages`, no Mason)
- `lib/`               flake helpers: `mkSystem`, `mkHome` (wires overlays, shojiwm module, `unstable`, `backupFileExtension`)
- `overlays/`          one file per concern (`ly`, `nvidia`, `waybar`, `bibata`) composed in `default.nix` + local packages
- `pkgs/`              custom packages (callPackage-able)
  - `pkgs/my-package/` custom package definition (`default.nix`)
  - `pkgs/scripts.nix`  custom scripts: `nix-rebuild`, `nix-check` (as `pkgs.myScripts.*`)
- `patches/`           upstream fix patches applied by overlays (ly bigclock color, waybar lua dispatch, optional nvidia kernel patch)
- `devshells/`         per-language dev shells
  - `devshells/common.nix` shared devshell template (base tools + `packages` param)

## Commands

- bootstrap:    `./setup.sh` (or `./setup.sh --mode dry|test|boot`)
- rebuild:      `sudo nixos-rebuild switch --flake .#h4ck1ng-h0st`
- dry build:    `sudo nixos-rebuild build --flake .#h4ck1ng-h0st`
- home:         `home-manager switch --flake .#koki`
- check:        `nix flake check`
- shells:       `nix develop` (or `. /devshells/...` via direnv)
- format:       `nix fmt`

## Conventions

- Host entry files are always `default.nix`.
- System modules own enablement (`myDesktop.*.enable`, services); home modules own user config. Never write `home-manager.users.*` from `modules/`.
- nvim lives only in `home/koki/programs/nvim/`.
- Fonts live only in `modules/desktop/fonts.nix`.
- Only `h4ck1ng-h0st` is wired as a buildable configuration; other hosts are stubs.
- Add a new module: create the file under `modules/`, import it from `hosts/<host>/default.nix`.
- Add a new home module: create the file under `home/koki/`, import it from `home/koki/default.nix`.
- Empty module files should include a `# Placeholder — pending implementation` comment.
- Stub hosts (desktop, laptop, vm) share `hosts/common.nix` for their hardware configuration.
- Devshells share `devshells/common.nix` as a template.
- SSH: password logins off — add keys in `modules/services/ssh.nix` before relying on remote access.
