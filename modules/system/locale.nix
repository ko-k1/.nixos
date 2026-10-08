{
  config,
  lib,
  pkgs,
  ...
}:
{
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  # Japanese input via fcitx5 + mozc. Sets GTK_IM_MODULE / QT_IM_MODULE /
  # XMODIFIERS / INPUT_METHOD for the whole session.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      qt6Packages.fcitx5-configtool
    ];
  };
}
