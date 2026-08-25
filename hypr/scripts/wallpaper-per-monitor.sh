#!/usr/bin/env bash
# Keep a dedicated wallpaper on the vertical monitor.
#
# ML4W has no concept of a per-monitor wallpaper: its cache is a single
# current_wallpaper, and ml4w-autostart calls ml4w-wallpaper with no --monitor,
# which awww applies to EVERY output. So the portrait image gets overwritten by
# the main display's wallpaper at each login and on every wallpaper change.
#
# --skip-theming is deliberate: the desktop palette (matugen, rofi, swaync)
# should be derived from the main display's wallpaper, not from this one.
# Without it, setting the portrait image re-themes the entire desktop.

set -uo pipefail

MONITOR="${MONITOR:-DP-2}"
IMAGE="${IMAGE:-$HOME/personal/assets/wallpaper/khashayar-kouchpeydeh-FKkbWrV2SKo-unsplash.jpg}"
SETTER="$HOME/.config/ml4w/scripts/ml4w-wallpaper"

usage() {
    cat <<EOF
usage: ${0##*/} [--once|--watch] [--monitor OUTPUT] [--image PATH]

  --once    apply one time and exit
  --watch   apply, then re-apply whenever something else overwrites it (default)

env: MONITOR, IMAGE
EOF
}

mode="watch"
while [ $# -gt 0 ]; do
    case "$1" in
        --once)    mode="once"; shift ;;
        --watch)   mode="watch"; shift ;;
        --monitor) MONITOR="$2"; shift 2 ;;
        --image)   IMAGE="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
done

[ -f "$IMAGE" ]  || { echo "image not found: $IMAGE" >&2; exit 1; }
[ -x "$SETTER" ] || { echo "ml4w-wallpaper not found: $SETTER" >&2; exit 1; }

# awww-daemon is started by conf/autostart.lua; it may not be up yet at login.
wait_for_awww() {
    local waited=0
    until awww query >/dev/null 2>&1; do
        sleep 0.5
        waited=$((waited + 1))
        [ "$waited" -ge 60 ] && { echo "awww-daemon not up after 30s" >&2; return 1; }
    done
}

# awww query prints one line per output:
#   : DP-2: 2160x3840, scale: 1, currently displaying: image: /path/to.jpg
current_image() {
    awww query 2>/dev/null | awk -v m=": ${MONITOR}:" '
        index($0, m) == 1 { sub(/.*currently displaying: image: /, ""); print; exit }'
}

apply() {
    "$SETTER" "$IMAGE" --monitor "$MONITOR" --skip-theming >/dev/null 2>&1
}

wait_for_awww || exit 1

case "$mode" in
    once)
        [ "$(current_image)" = "$IMAGE" ] || apply
        ;;
    watch)
        # The login race: ml4w-autostart applies the main wallpaper to all
        # outputs in the background, so a single early apply loses. Re-checking
        # also covers every later wallpaper change the user makes by hand.
        while true; do
            if awww query >/dev/null 2>&1; then
                [ "$(current_image)" = "$IMAGE" ] || apply
            fi
            sleep 5
        done
        ;;
esac
