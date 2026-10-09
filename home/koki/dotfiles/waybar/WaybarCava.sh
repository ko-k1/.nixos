#!/usr/bin/env bash
bar="▁▂▃▄▅▆▇█"

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
framerate = 90
bars = 10
autosens = 1

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7

[smoothing]
noise_reduction = 0.15
gravity = 0.50
monstercat = 0
waves = 0
EOF

pkill -f "cava -p $config_file"

cava -p "$config_file" | awk -F';' -v alpha=0.1 '
BEGIN { n = split("▁▂▃▄▅▆▇█", g, ""); }
{
    for (i = 1; i < NF; i++) {
        v = $i + 0
        if (v < 0) v = 0
        if (v > 7) v = 7
        if (has_prev) s[i] = (1 - alpha) * s[i] + alpha * v
        else        s[i] = v
    }
    has_prev = 1
    for (i = 1; i < NF; i++) {
        c = int(s[i] + 0.5)
        if (c < 0) c = 0
        if (c > 7) c = 7
        printf "%s", g[c + 1]
    }
    printf "\n"
    fflush()
}'
