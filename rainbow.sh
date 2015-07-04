#!/bin/sh
#
# z3bra - 2015 (c) wtfpl
# make the current window "rainbowish"... Awesome idea from xero@nixers.net !

FREQ=${FREQ:-0.15}
CUR=$(pfw)

while :; do
    IFS=$'\n'
    for i in $(tail -n 10 ~/.Xdefaults | grep color)
    do
      c=$(printf $i | cut -d ":" -f 2 | tr -d '#')
      chwb -c $c $(pfw) 
      sleep $FREQ
    done
done
