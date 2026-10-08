# koki's NixOS configuration (v2)

Flake-managed NixOS + Home Manager + devshells + direnv setup.

## Layout

- `flake.nix`          entrypoint: inputs, nixosConfigurations, homeConfigurations, devShells, overlays, formatter
- `hosts/<name>/`      machine entries: `default.nix` (imports modules) + `hardware-configuration.nix`
  - `hosts/common.nix` shared helper for stub hardware configurations (used by desktop, laptop, vm)
- `modules/`           system modules, grouped by concern:
  - `system/` boot, locale, networking, security, users
  - `desktop/` audio, fonts, hyprland, niri, waybar
  - `development/` git, languages, tool
  - `hardware/` amd, nvidia
  - `services/` docker, podman, ssh
- `home/<user>/`       Home Manager modules: `default.nix` + per-program files
  - `programs/nvim/`   nvim split into completion/keymap/lsp/options/plugins/treesitter
- `lib/`               flake helpers: `mkSystem`, `mkHome` (configurable `system` and `user` params)
- `overlays/`          nixpkgs overlays (flake output `overlays.default`; adds `my-package`, `scripts`)
- `pkgs/`              custom packages (callPackage-able)
  - `pkgs/my-package/` custom package definition (`default.nix`)
  - `pkgs/scripts.nix`  custom scripts: `nix-rebuild`, `nix-check`
- `devshells/`         per-language dev shells
  - `devshells/common.nix` shared devshell template (base tools + `packages` param)
- `patches/ secrets/ shells/ templates/`   reserved dirs (empty)

## Commands

- rebuild:      `sudo nixos-rebuild switch --flake .#h4ck1ng-h0st`
- dry build:    `sudo nixos-rebuild build --flake .#h4ck1ng-h0st`
- home:         `home-manager switch --flake .#koki`
- check:        `nix flake check`
- shells:       `nix develop` (or `. /devshells/...` via direnv)
- format:       `nix fmt`

## Conventions

- Host entry files are always `default.nix`.
- nvim lives only in `home/koki/programs/nvim/`.
- Fonts live only in `modules/desktop/fonts.nix`.
- Only `h4ck1ng-h0st` is wired as a buildable configuration; other hosts are stubs.
- Add a new module: create the file under `modules/`, import it from `hosts/<host>/default.nix`.
- Add a new home module: create the file under `home/koki/`, import it from `home/koki/default.nix`.
- Empty module files should include a `# Placeholder — pending implementation` comment.
- Stub hosts (desktop, laptop, vm) share `hosts/common.nix` for their hardware configuration.
- Devshells share `devshells/common.nix` as a template.
