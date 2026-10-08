#!/usr/bin/env bash
#      __   __  __
#    __\ \__\ \/ /
#   /________\  / /\         _   __      _____  _____
#   ___/ /    \ \/ /        / | / (_) __/ ___ \/ ,__/
#  /__  /      \/ /__      /  |/ / /\/ / /  / /\ \
#    / /\      / ___/  __ / /|  / /> </ /__/ /__\ \
#   / /\ \____/_/__   /_//_/ |_/_/_/\_\_____/_____/
#   \/ /\ \___  __/
#     /_/\_\  \_\
# .nixos — one-shot NixOS bootstrap.
#
#   ./setup.sh [--host h4ck1ng-h0st] [--mode switch|boot|test|dry] [-y]
#
# Does, in order:
#   1. preflight (nix + flakes, repo root, sudo)
#   2. ensures hosts/<host>/hardware-configuration.nix exists
#      (copies the live one from /etc/nixos on a fresh machine)
#   3. one `nixos-rebuild` run — Home Manager, overlays, devshells included.
#
# After install, day-to-day rebuilds are just:
#   sudo nixos-rebuild switch --flake .#h4ck1ng-h0st   (or `nix-rebuild`)
set -euo pipefail

HOST="h4ck1ng-h0st"
MODE="switch" # switch | boot | test | dry
ASSUME_YES=0
FORCE_TUI=0
NO_TUI=0
GAVE_ARG=0

usage() {
  cat <<EOF
Usage: ./setup.sh [--host NAME] [--mode switch|boot|test|dry] [-y] [--tui|--no-tui]

  --host NAME   NixOS configuration to apply (default: h4ck1ng-h0st)
  --mode MODE   switch (default), boot, test, or dry (build only, no sudo)
  -y, --yes     skip the confirmation prompt (also disables TUI menu)
  --tui         force interactive menu (when stdin/stdout is a TTY)
  --no-tui      plain log output, no banner/menu (for CI)
  -h, --help    show this help

No args + TTY -> minimal TUI menu. Any --host/--mode arg -> classic CLI.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="${2:?--host needs a value}"; GAVE_ARG=1; shift 2 ;;
    --mode) MODE="${2:?--mode needs a value}"; GAVE_ARG=1; shift 2 ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    --tui) FORCE_TUI=1; shift ;;
    --no-tui) NO_TUI=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "error: unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

# --- minimal TUI helpers (bash-only, no deps) -------------------------------
if [[ -t 1 && "${TERM:-dumb}" != "dumb" && "$NO_TUI" -ne 1 ]]; then
  C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'; C_BLUE=$'\033[1;34m'
  C_GREEN=$'\033[1;32m'; C_YELLOW=$'\033[1;33m'; C_RED=$'\033[1;31m'
  C_RESET=$'\033[0m'
else
  C_BOLD=''; C_DIM=''; C_BLUE=''; C_GREEN=''; C_YELLOW=''; C_RED=''; C_RESET=''
fi
USE_TUI=0
if [[ "$NO_TUI" -ne 1 && "$ASSUME_YES" -ne 1 ]]; then
  if [[ "$FORCE_TUI" -eq 1 ]]; then
    USE_TUI=1
  elif [[ "$FORCE_TUI" -eq 0 && "$GAVE_ARG" -eq 0 && -t 0 && -t 1 ]]; then
    USE_TUI=1
  fi
fi

tui_banner() {
  [[ "$USE_TUI" -eq 1 ]] || return 0
  printf '%s\n' "${C_BLUE}${C_BOLD}┌──────────────────────────────────────────┐${C_RESET}"
  printf '%s\n' "${C_BLUE}${C_BOLD}│${C_RESET}  ${C_BOLD}.nixos — one-shot NixOS bootstrap${C_RESET}       ${C_BLUE}${C_BOLD}│${C_RESET}"
  printf '%s\n' "${C_BLUE}${C_BOLD}└──────────────────────────────────────────┘${C_RESET}"
}
log()  { printf '%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
warn() { printf '%s[!]%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()  { printf '%s[✗]%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }
ok()   { printf '%s[✓]%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }

tui_hr() { [[ "$USE_TUI" -eq 1 ]] && printf '%s\n' "${C_DIM}────────────────────────────────────────────${C_RESET}"; }
tui_step() { # tui_step <n> <total> <label>
  if [[ "$USE_TUI" -eq 1 ]]; then
    printf '\n%s[%s %s/%s]%s %s%s%s\n' "${C_BLUE}${C_BOLD}" "$1" "$2" "${C_RESET}" "${C_BOLD}" "$3" "${C_RESET}"
  else
    log "[$1/$2] $3"
  fi
}
tui_menu() { # tui_menu <prompt> <default> <opt...> -> prints choice to stdout
  local prompt="$1" def="$2"; shift 2
  local opts=("$@") i n choice
  n=$#
  printf '%s %s%s%s\n' "${C_BOLD}?" "${C_RESET}" "$prompt" >&2
  for i in "${!opts[@]}"; do
    if [[ $((i + 1)) -eq "$def" ]]; then
      printf '  %s[%d]%s %s %s(default)%s\n' "$C_GREEN" "$((i + 1))" "$C_RESET" "${opts[$i]}" "$C_DIM" "$C_RESET" >&2
    else
      printf '  %s[%d]%s %s\n' "$C_DIM" "$((i + 1))" "$C_RESET" "${opts[$i]}" >&2
    fi
  done
  printf 'Select [1-%d, default %d]: ' "$n" "$def" >&2
  if ! read -r choice </dev/tty; then choice="$def"; fi
  [[ "$choice" =~ ^[0-9]+$ ]] || choice="$def"
  ((choice >= 1 && choice <= n)) || choice="$def"
  printf '%s' "${opts[$((choice - 1))]}"
}
tui_confirm() { # tui_confirm <prompt> -> 0=yes
  local prompt="$1" ans
  printf '\n%s %s [y/N]: %s' "${C_BOLD}${C_YELLOW}?${C_RESET}" "$prompt" ""
  if ! read -r ans </dev/tty; then return 1; fi
  [[ "${ans,,}" == "y" || "${ans,,}" == "yes" ]]
}
tui_summary() { # tui_summary
  [[ "$USE_TUI" -eq 1 ]] || return 0
  printf '\n%s\n' "${C_BLUE}┌─ plan ────────────────────────────────┐${C_RESET}"
  printf '  host : %s%s%s\n' "$C_BOLD" "$HOST" "$C_RESET"
  printf '  mode : %s%s%s\n' "$C_BOLD" "$MODE" "$C_RESET"
  printf '  flake: .#%s\n' "$HOST"
  printf '%s\n' "${C_BLUE}└─────────────────────────────────────────┘${C_RESET}"
}

case "$MODE" in
  switch|boot|test|dry) ;;
  *) echo "error: --mode must be switch|boot|test|dry (got: $MODE)" >&2; exit 1 ;;
esac

tui_banner

# --- 0. interactive menu (only when no CLI args + TTY) -----------------------
#custom setup.sh args manual configuration begin
if [[ "$USE_TUI" -eq 1 ]]; then
  mapfile -t _HOSTS < <(for d in ./hosts/*/; do [[ -f "${d}default.nix" ]] && basename "$d"; done | sort)
  [[ ${#_HOSTS[@]} -gt 0 ]] || _HOSTS=("$HOST")
  _def=1
  for _i in "${!_HOSTS[@]}"; do [[ "${_HOSTS[$_i]}" == "$HOST" ]] && _def=$((_i + 1)); done
  if [[ ${#_HOSTS[@]} -gt 1 ]]; then
    HOST="$(tui_menu "Which host to apply?" "$_def" "${_HOSTS[@]}")"
  else
    log "host: ${HOST}"
  fi
  #selection tui menu begin
  _MODE_LABEL="$(tui_menu "Which mode?" "1" \
    "switch — activate now" \
    "boot — activate on next reboot" \
    "test — activate until reboot" \
    "dry — build only, no sudo")"
  #selection tui menu end
  case "$_MODE_LABEL" in
    switch*) MODE="switch" ;;
    boot*) MODE="boot" ;;
    test*) MODE="test" ;;
    dry*) MODE="dry" ;;
  esac
  tui_hr
  log "selected: host=${HOST} mode=${MODE}"
fi
#custom setup.sh args manual configuration end

# --- 1. preflight -----------------------------------------------------------
[[ -f ./flake.nix ]] || die "run ./setup.sh from the repo root (flake.nix not found)."
command -v nix >/dev/null 2>&1 || die "nix is not installed. Install NixOS or nix first."

if ! nix --extra-experimental-features 'nix-command flakes' flake show >/dev/null 2>&1; then
  warn "could not evaluate the flake (offline? missing inputs?)."
  warn "run 'nix flake lock' once with network access, then retry."
fi

HOST_DIR="./hosts/${HOST}"
[[ -d "$HOST_DIR" ]] || die "unknown host '${HOST}' (no ${HOST_DIR}/)."

# --- 2. hardware configuration ----------------------------------------------
if [[ ! -s "${HOST_DIR}/hardware-configuration.nix" ]]; then
  log "no hardware-configuration.nix for ${HOST}; generating from this machine."
  if [[ -f /etc/nixos/hardware-configuration.nix ]]; then
    cp /etc/nixos/hardware-configuration.nix "${HOST_DIR}/hardware-configuration.nix"
    log "copied /etc/nixos/hardware-configuration.nix."
  else
    sudo nixos-generate-config --show-hardware-config >"${HOST_DIR}/hardware-configuration.nix"
    log "generated via nixos-generate-config."
  fi
else
  log "hardware-configuration.nix present."
fi

# --- 3. apply ----------------------------------------------------------------
#install begin
FLAKE_REF=".#${HOST}"
case "$MODE" in
  dry)
    TOPLEVEL=".#nixosConfigurations.${HOST}.config.system.build.toplevel"
    log "dry build: nix build ${TOPLEVEL}"
    nix build "$TOPLEVEL" --show-trace
    ok "build OK. Re-run without --mode dry to apply."
    exit 0
    ;;
  switch)
    CMD=(sudo nixos-rebuild switch --flake "$FLAKE_REF" --show-trace)
    ;;
  boot)
    CMD=(sudo nixos-rebuild boot --flake "$FLAKE_REF" --show-trace)
    ;;
  test)
    CMD=(sudo nixos-rebuild test --flake "$FLAKE_REF" --show-trace)
    ;;
esac

tui_summary
log "about to run: ${CMD[*]}"
if [[ "$ASSUME_YES" -ne 1 ]]; then
  if [[ "$USE_TUI" -eq 1 ]]; then
    tui_confirm "Apply ${HOST} (${MODE})?" || die "aborted."
  else
    read -r -p "Apply ${HOST} (${MODE})? [y/N] " answer
    [[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]] || die "aborted."
  fi
fi

"${CMD[@]}"
ok "done. Reboot if the kernel/display stack changed."
#install end

# Post-install reminders (informational only):
#   passwd koki                                   # set the user password
#   + add SSH keys in modules/services/ssh.nix, then rebuild
