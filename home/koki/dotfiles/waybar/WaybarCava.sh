#!/usr/bin/env bash

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
framerate = 60
bars = 10
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

pkill -f "cava -p $config_file"

cava -p "$config_file" | awk -F';' -v sq="'" '
BEGIN {
    n = split("0 1 2 4 5 6 7 8 9", H, " ")
    for (k = 1; k <= n; k++) inh[H[k]] = 1
    for (t = 0; t <= 18; t++) {
        if (t <= 9) {
            b = t
            while (b > 0 && !(b in inh)) b--
            bh[t] = b
            th[t] = 0
        } else {
            o = t - 9
            while (o > 0 && !(o in inh)) o--
            bh[t] = 9
            th[t] = o
        }
    }
    split("▁▂▃▄▅▆▇█", GL, "")
    h2g[0] = " "
    for (k = 1; k <= 8; k++) h2g[H[k + 1]] = GL[k]
    bh[0] = 1
    sp = "<span line_height=" sq "0.8" sq ">"
    ep = "</span>"
}
{
    top = ""; bot = ""
    for (i = 1; i < NF; i++) {
        v = $i + 0
        if (v > 1000) v = 1000
        if (v < 0) v = 0
        t = int(0.5 + v * 18 / 1000)
        bot = bot h2g[bh[t]] h2g[bh[t]]
        top = top h2g[th[t]] h2g[th[t]]
    }
    printf "{\"text\": \"%s%s%s\\n%s%s%s\"}\n", sp, top, ep, sp, bot, ep
    fflush()
}'
