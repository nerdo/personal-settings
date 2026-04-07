#!/usr/bin/env bash
# Custom cliphist wrapper that doesn't clear clipboard on escape

launcher=$(cat "$HOME/.config/ml4w/settings/launcher")
if [ "$launcher" == "walker" ]; then
    "$HOME/.config/walker/launch.sh" -m clipboard -N -H
else
    case $1 in
        d)
            cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi | cliphist delete
        ;;
        w)
            cliphist wipe
        ;;
        *)
            selected=$(cliphist list | rofi -dmenu -replace -config ~/.config/rofi/config-cliphist.rasi)
            if [ -n "$selected" ]; then
                echo "$selected" | cliphist decode | wl-copy
            fi
        ;;
    esac
fi
