# ko-k1/zsuggestion: nvim-style bordered suggestion popup for Zsh.
# Pinned to an exact commit so upstream pushes don't break builds; the
# vendored crates come from that commit's own Cargo.lock via cargoHash.
{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "zsuggestion";
  version = "unstable-2026-08-21";
  src = fetchFromGitHub {
    owner = "ko-k1";
    repo = "zsuggestion";
    rev = "7986216c735850e200a93a88dd12f37775ba3797";
    sha256 = "1f3q4qbqdmzn556kzq7s8fjm864zjr874zn287xh85xp74mzas13";
  };
  cargoHash = "sha256-PC/PosTXiyrm8bWhwBxMr4U7Auy/8L1llC5yKFHgLbU=";
  doCheck = false;
}
