#!/usr/bin/env bash

player=""
for p in $(busctl --user list --no-pager 2>/dev/null | awk '$1 ~ /^org\.mpris\.MediaPlayer2\./ {print $1}'); do
  st=$(busctl --user get-property "$p" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null | awk '{print $NF}' | tr -d '"')
  [ "$st" = "Playing" ] && player="$p" && break
  [ -z "$player" ] && player="$p"
done

if [ -z "$player" ]; then
  echo '{"text":"","class":"stopped","tooltip":""}'
  exit 0
fi

meta=$(busctl --user get-property "$player" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Metadata 2>/dev/null)
raw_title=$(echo "$meta" | grep -oP 'xesam:title" s "\K[^"]*' | head -1)
raw_artist=$(echo "$meta" | grep -oP 'xesam:artist" as \d+ "\K[^"]*' | head -1)
raw_album=$(echo "$meta" | grep -oP 'xesam:album" s "\K[^"]*' | head -1)
status=$(busctl --user get-property "$player" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null | awk '{print $NF}' | tr -d '"' | tr '[:upper:]' '[:lower:]')

title=$(printf '%b' "$raw_title")
artist=$(printf '%b' "$raw_artist")
album=$(printf '%b' "$raw_album")

[ -z "$title" ] && title="$album"
[ -z "$title" ] && title="♪"

text="${title}"
tooltip=""
[ -n "$artist" ] && tooltip="${artist}"
[ -n "$album" ] && [ -n "$tooltip" ] && tooltip="${tooltip} - ${album}"
[ -z "$tooltip" ] && [ -n "$album" ] && tooltip="$album"

escape() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

printf '{"text":"%s","class":"%s","tooltip":"%s"}' "$(echo "$text" | escape)" "$status" "$(echo "$tooltip" | escape)"
