#!/usr/bin/env bash
mode=${1:-cpu}
width=${2:-5}
interval=${3:-0.5}
samples=$((width * 2))
col0=(1 2 4 64)
col1=(8 16 32 128)
levels=()

cpu_stat() {
    awk '/^cpu /{ idle = $5 + $6; total = 0; for (i = 2; i <= 9; i++) total += $i; print total, idle }' /proc/stat
}

read -r prev_total prev_idle < <(cpu_stat)

while :; do
    sleep "$interval"

    if [ "$mode" = "mem" ]; then
        read -r total avail < <(awk '/^MemTotal:/{t = $2} /^MemAvailable:/{a = $2} END{print t, a}' /proc/meminfo)
        used=$((total - avail))
        pct=$((used * 100 / total))
        tip=$(awk -v u="$used" -v t="$total" 'BEGIN{printf "RAM %.1fG/%.1fG (%d%%)", u/1048576, t/1048576, u*100/t}')
    else
        read -r total idle < <(cpu_stat)
        dt=$((total - prev_total))
        di=$((idle - prev_idle))
        prev_total=$total
        prev_idle=$idle
        if [ "$dt" -gt 0 ]; then pct=$(( (dt - di) * 100 / dt )); else pct=0; fi
        [ "$pct" -lt 0 ] && pct=0
        [ "$pct" -gt 100 ] && pct=100
        tip="CPU ${pct}%"
    fi

    lvl=$(( pct == 0 ? 0 : (pct * 4 + 99) / 100 ))
    [ "$lvl" -gt 4 ] && lvl=4
    levels+=("$lvl")
    [ "${#levels[@]}" -gt "$samples" ] && levels=("${levels[@]:1}")

    pad=$((samples - ${#levels[@]}))
    out=""
    for ((c = 0; c < width; c++)); do
        mask=0
        for j in 0 1; do
            idx=$((2 * c + j - pad))
            [ "$idx" -lt 0 ] && continue
            v=${levels[$idx]}
            for ((r = 4 - v; r < 4; r++)); do
                if [ "$j" -eq 0 ]; then mask=$((mask + ${col0[$r]})); else mask=$((mask + ${col1[$r]})); fi
            done
        done
        if [ "$mask" -eq 0 ]; then
            out+=" "
        else
            printf -v ch "\\U$(printf '%08X' $((0x2800 + mask)))"
            out+="$ch"
        fi
    done

    printf '{"text":"%s%s","tooltip":"%s"}\n' "$out" "${pct}%" "$tip"
done
