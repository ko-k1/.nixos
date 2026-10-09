# ko-k1/zsuggestion: nvim-style bordered suggestion popup for Zsh.
# Pinned to an exact commit so upstream pushes don't break builds.
{
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
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
  cargoLock = {
    lockFile = fetchurl {
      url = "https://raw.githubusercontent.com/ko-k1/zsuggestion/main/Cargo.lock";
      sha256 = "0fbvkvw9mm4s5lbkmiiw40jb4hs93kp5gm3m210h1lv13chmjhvm";
    };
  };
  doCheck = false;
}
