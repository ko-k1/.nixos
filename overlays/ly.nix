# ly display manager: adds a `bigclock_fg` color setting (upstream hardcodes
# the big clock to fg). Patch lives in ../../patches/ly-bigclock-color.patch.
final: prev: {
  ly = prev.ly.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/ly-bigclock-color.patch ];
  });
}
