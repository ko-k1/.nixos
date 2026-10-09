{
  lib,
  fetchFromGitHub,
  mkHyprlandPlugin,
  hyprland,
  wayland-scanner,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprglass";
  version = "0.9.1";

  # Build against the running Hyprland to avoid ABI mismatch.
  hyprland = hyprland;

  # v0.9.x generates the hyprglass-item-v1 protocol at build time.
  nativeBuildInputs = [ wayland-scanner ];

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "99f30ca394bd0058ee79bf1c272c320f223e4540"; # v0.9.1, Hyprland 0.56.2
    hash = "sha256-V8w1SLd9u2wfMh0kvFkHbhV9I5wDQey0S2SyfvGo2LM=";
  };

  # Makefile project (no cmake); pkg-config is auto-added by mkHyprlandPlugin.
  # No 'make install' target upstream, so install the .so manually to the
  # path home-manager expects: $out/lib/lib<pluginName>.so
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
    runHook postInstall
  '';

  meta = {
    description = "Liquid Glass (blur, refraction, chromatic aberration) plugin for Hyprland";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
