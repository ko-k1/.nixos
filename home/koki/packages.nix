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

    # Terminals. kitty/foot come from programs.* (programs/kitty.nix,
    # programs/foot.nix); the rest run stock or with verbatim dotfiles.
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

    # CLI and shell tools (starship/fzf/tmux come from programs.*).
    fastfetch
    eza
    btop
    cava
    unstable.opencode
    unstable.claude-code
    # JS: bun is the package manager/runner (`bunx`, no npm). nodejs-slim is
    # only the `node` runtime (no npm/npx) for Claude Code plugin hooks: ECC's
    # hooks run `node -e`, which bun can't stand in for (argv layout differs).
    bun
    nodejs-slim
    nvtopPackages.full
    p7zip
    gh
    openssl
    nmap
    uv
    jq
    ripgrep
    fd
    bat
    ncdu
    unzip
    zip
    which
    mercurial
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

    # GTK/Qt theme, icons and cursor live in theme.nix; fonts in
    # modules/desktop/fonts.nix.
    openh264
    ffmpeg
  ];
}
