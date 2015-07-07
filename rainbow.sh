#!/bin/sh
#
# z3bra - 2015 (c) wtfpl
# make the current window "rainbowish"... Awesome idea from xero@nixers.net !

FREQ=${FREQ:-0.2}
CUR=$(pfw)

opt=""
cont=0

while :; do
    IFS=$'\n'
    for i in $(grep color .Xdefaults | sort -V $opt)
    do
      cont=$((cont+1))
      c=$(printf $i | cut -d ":" -f 2 | tr -d '#')
      chwb -c $c $(pfw) 
      sleep $FREQ
      case $cont in
        6)
          cont=0
          if [[ $opt == -r ]]; then
            opt="" 
          else
            opt="-r"
          fi
          ;;
      esac
    done
done
