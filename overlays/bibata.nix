# Bibata-Modern-Ice cursor theme (xcursor + Hyprcursor), built from source
# because nixpkgs does not ship the Hyprcursor variant.
final: prev: {
  bibata-cursor-themes = prev.stdenvNoCC.mkDerivation rec {
    pname = "bibata-cursor-themes";
    version = "2.0.7";

    src = prev.fetchFromGitHub {
      owner = "ful1e5";
      repo = "Bibata_Cursor";
      rev = "v${version}";
      hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
    };

    bitmaps = prev.fetchzip {
      url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/bitmaps.zip";
      hash = "sha256-4VjyNWry0NPnt5+s0od/p18gry2O0ZrknYZh+PAPM8Q=";
    };

    nativeBuildInputs = with prev; [
      clickgen
      xcur2png
      hyprcursor
    ];

    buildPhase = ''
      runHook preBuild

      VARIANT=Bibata-Modern-Ice
      ctgen configs/normal/x.build.toml -p x11 -d "$bitmaps/$VARIANT" -n "$VARIANT" -c 'White and rounded edge Bibata XCursors'

      # clickgen has no hyprcursor platform, so convert the xcursor theme
      # with hyprcursor-util: --extract decompiles .cursor -> PNG+meta,
      # --create compiles PNG+meta into loadable .hlc zips.
      rm -rf extract compile
      mkdir -p extract compile
      hyprcursor-util --extract "themes/$VARIANT" -o "$(pwd)/extract"
      sed -i "s/^name = .*/name = $VARIANT/" "extract/extracted_$VARIANT/manifest.hl"
      hyprcursor-util --create "extract/extracted_$VARIANT" -o "$(pwd)/compile"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      VARIANT=Bibata-Modern-Ice
      mkdir -p $out/share/icons
      cp -rf "themes/$VARIANT" "$out/share/icons/$VARIANT"
      cp -rf "compile/theme_$VARIANT" "$out/share/icons/$VARIANT.theme"

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Bibata-Modern-Ice cursor theme (xcursor + Hyprcursor)";
      homepage = "https://github.com/ful1e5/Bibata_Cursor";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
    };
  };
}
