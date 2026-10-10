# Desktop apps that need system-level integration (setuid, wrappers,
# xdg portals) rather than a plain user install.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    # steam-run is also the FHS runtime for Mozilla's prebuilt Firefox
    # binaries (Aequera artifact builds, tools/build/nixos-env.sh). The
    # steam FHS no longer ships GTK 3, which they link directly.
    package = pkgs.steam.override {
      extraLibraries =
        p: with p; [
          gtk3
          at-spi2-core
          libxcomposite
        ];
    };
  };
  programs.wireshark.enable = true;
}
