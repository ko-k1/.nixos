# Claude Desktop (system side). Official Anthropic Linux build via
# github:nmcbride/claude-desktop-nixos (see flake.nix inputs).
# Needs system-level integration for Cowork's micro-VM sandbox
# (/usr/share/OVMF + /usr/libexec/virtiofsd symlinks, vhost_vsock,
# kvm group), so it lives here rather than home.packages.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.claude-desktop = {
    enable = true;
    # Build against our pkgs (overlays + nixpkgsConfig) instead of the
    # flake's own `import nixpkgs` instance.
    package = pkgs.callPackage "${inputs.claude-desktop}/package.nix" { };
    # Cowork runs agent work inside a QEMU micro-VM and needs /dev/kvm
    # access. Add the primary user here; re-log after first switch
    # for the extra group to take effect.
    cowork.kvmUsers = [ "koki" ];
  };
}
