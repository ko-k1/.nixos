# koki's NixOS configuration

Flake-managed NixOS + Home Manager + devshells + direnv, applied with one command:

```sh
./setup.sh                 # switch to .#h4ck1ng-h0st (prompts once to confirm)
./setup.sh -y              # same, no prompt
./setup.sh --mode dry      # build only, no sudo, no changes
./setup.sh --mode boot     # activate on next reboot
./setup.sh --mode test     # activate until next reboot
```

Day-to-day (after bootstrap): `sudo nixos-rebuild switch --flake .#h4ck1ng-h0st`
(or the `nix-rebuild` helper). Other helpers: `nix flake check`, `nix fmt`,
`nix develop` (per-language shells in `devshells/`).

## After a fresh install

1. `passwd koki` — set the user password (no default is shipped).
2. Add SSH public key(s) in `modules/services/ssh.nix`, then rebuild
   (password logins are disabled by default).
3. `nix flake lock` once with network access if inputs were edited.

## Hosts

- `h4ck1ng-h0st` — AMD CPU + NVIDIA RTX 2080 Ti, ly → Hyprland / Niri / ShojiWM.
  The only wired configuration; `desktop`, `laptop`, `vm` are stubs.
- Compositors toggle via `myDesktop.{hyprland,niri,shojiwm}.enable`
  (all default on; pick your session in ly).
