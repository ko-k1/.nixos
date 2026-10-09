#!/usr/bin/env bash

action="${1:-PlayPause}"

player=""
for p in $(busctl --user list --no-pager 2>/dev/null | awk '$1 ~ /^org\.mpris\.MediaPlayer2\./ {print $1}'); do
  st=$(busctl --user get-property "$p" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null | awk '{print $NF}' | tr -d '"')
  [ "$st" = "Playing" ] && player="$p" && break
  [ -z "$player" ] && player="$p"
done

[ -z "$player" ] && exit 1

busctl --user call "$player" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player "$action" 2>/dev/null
