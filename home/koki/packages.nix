# Everything installed into the user profile. System-level tools
# (vim, git, curl for rescue) live in modules/system/packages.nix instead.
# `unstable` comes from lib/helpers.nix extraSpecialArgs.
{
  config,
  pkgs,
  unstable,
  ...
}:
{
  home.packages = with pkgs; [
    # Shells. `dash` supplies a small POSIX sh implementation.
    bash
    dash
    zsh
    fish

    # Desktop environment helpers.
    swaybg
    swaylock
    awww
    wlogout
    rofi
    fuzzel
    hyprshot
    hyprpaper
    nwg-dock-hyprland

    # Terminals (kitty/foot configured via programs.*; rest stock).
    kitty
    foot
    alacritty
    wezterm
    ghostty

    # File explorer / archives / image viewer.
    thunar
    file-roller
    kdePackages.ark
    loupe

    # Social.
    equibop
    discord

    # Audio / video.
    pavucontrol
    vlc
    mpv
    audacity
    easyeffects

    # Multimedia & creative.
    gimp
    krita
    blender
    shotcut
    handbrake
    obs-studio

    # Text editors (neovim via programs.neovim).
    sublime4
    vscode
    zed-editor

    # AI and local LLM things.
    lmstudio
    llama-cpp
    python313Packages.huggingface-hub

    # Pentesting.
    zenmap
    metasploit
    john
    hashcat
    hydra
    sqlmap
    gobuster
    nikto

    # Remote computing.
    parsec-bin

    # CLI and shell tools.
    fastfetch
    eza
    btop
    cava
    unstable.opencode
    pkgs.nvtopPackages.full
    starship
    p7zip
    gh
    openssl
    nmap
    uv
    jq
    ripgrep
    fd
    fzf
    tmux
    bat
    ncdu
    unzip
    unrar
    netcat-openbsd
    tcpdump

    # Rebuild helpers from pkgs/scripts.nix.
    myScripts.nix-rebuild
    myScripts.nix-check

    # GTK/Qt runtimes and desktop integration.
    gtk3
    gtk4
    qt5.qtbase
    qt6.qtbase

    # Theme, icons, cursor, fonts.
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
    hackgen-nf-font
    qt6Packages.qtstyleplugin-kvantum
    openh264
    ffmpeg
  ];
}
