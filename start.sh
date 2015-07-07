#!/bin/bash

sh ~/bin/bar.sh &
sleep .2 && xwininfo -name bar | awk 'NR==2 {print $4}' | xargs ignw -s
sh ~/wm/focus_watcher.sh &
