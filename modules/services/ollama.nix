# Ollama LLM server, usable from lmstudio etc.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.ollama.enable = true;
}
