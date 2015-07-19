#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

wew | while IFS=: read ev wid; do
    case $ev in
        # occurs on mapping requests
        17) sh ~/wm/focus.sh next;;
        19) wattr o $wid || sh ~/wm/focus.sh $wid;;
    esac
done
