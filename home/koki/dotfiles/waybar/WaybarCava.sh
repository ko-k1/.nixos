#!/usr/bin/env bash
# Two-row block-glyph spectrum for custom/cava_mviz.
#
# Pixel math (JetBrains Mono NF at style.css font-size 6.0606px = 200/33px):
# the block glyphs fill the whole 1320-unit cell, so one eighth (165 units)
# is exactly 1px and a full cell 8px. GTK3 hints the line box to 9px;
# line_height 7168 (7px pitch) overlaps the rows by 1px, which keeps every
# edge on the pixel grid and hides the row seam. The top row's ▁ sits behind
# that overlap, so the visible levels are 0..15 at 1px each.
# letter_spacing -1024 trims the hinted 4px advance to 3px so neighbouring
# glyphs overlap instead of leaving gaps.

bars=14 # even: stereo splits them L/R
glyphs=2
framerate=120

# Per-instance config: a fixed path + pkill made bars on different outputs
# kill each other's cava.
config_file=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/waybar-cava.XXXXXX")
trap 'kill "${cava_pid:-}" 2>/dev/null; rm -f "$config_file"' EXIT
trap 'exit' INT TERM HUP
cat >"$config_file" <<EOF
[general]
framerate = $framerate
bars = $bars
autosens = 1

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000

[smoothing]
noise_reduction = 77
monstercat = 0
waves = 0
EOF

# SIGPIPE arrives ignored (inherited) and cava ignores write errors, so in a
# plain pipeline cava outlives its reader once waybar is gone. Feed awk from
# a coproc instead and kill it from the EXIT trap.
coproc CAVA { exec cava -p "$config_file"; }
cava_pid=$CAVA_PID
awk -F';' -v glyphs="$glyphs" -v sq="'" '
function rep(s, n,    r) { r = ""; while (n-- > 0) r = r s; return r }
BEGIN {
    split("▁▂▃▄▅▆▇█", g, "")
    levels = 15
    for (l = 0; l <= levels; l++) {
        b = l < 1 ? 1 : (l > 8 ? 8 : l) # level 0 keeps the ▁ floor
        t = l > 8 ? l - 7 : 0
        bot[l] = rep(g[b], glyphs)
        top[l] = rep(t ? g[t] : " ", glyphs)
    }
    open = "<span line_height=" sq "7168" sq " letter_spacing=" sq "-1024" sq ">"
}
{
    t = ""; b = ""
    for (i = 1; i < NF; i++) {
        v = $i + 0
        if (v > 1000) v = 1000
        if (v < 0) v = 0
        l = int(0.5 + v * levels / 1000)
        t = t top[l]; b = b bot[l]
    }
    out = t "\\n" b
    if (out == prev) next # silence or no visible change: skip the redraw
    prev = out
    printf "{\"text\": \"%s%s</span>\"}\n", open, out
    fflush()
}' <&"${CAVA[0]}"
