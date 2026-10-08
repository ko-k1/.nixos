{
  config,
  lib,
  pkgs,
  ...
}:
{
  # rtkit lets PipeWire acquire realtime priority safely.
  security.rtkit.enable = true;

  # sudo keeps its default (wheel password required). Do NOT set
  # `wheelNeedsPassword = false` on a real machine.
}
