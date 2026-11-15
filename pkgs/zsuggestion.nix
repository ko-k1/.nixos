# ko-k1/zsuggestion: nvim-style bordered suggestion popup for Zsh.
# Pinned to an exact commit so upstream pushes don't break builds; the
# vendored crates come from that commit's own Cargo.lock via cargoHash.
{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "zsuggestion";
  version = "unstable-2026-11-15";
  src = fetchFromGitHub {
    owner = "ko-k1";
    repo = "zsuggestion";
    rev = "f8a96df09021a733f3a516c653724ff7c4797607";
    sha256 = "12lpmzlgigdzim32nkhq1jxkhv5gwvgdjiap3y783gi54ax0msnw";
  };
  cargoHash = "sha256-PC/PosTXiyrm8bWhwBxMr4U7Auy/8L1llC5yKFHgLbU=";
  doCheck = false;
}
