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
    if [[ $(pfw) -ne $CUR ]]; then
      chwb -c 151515 $CUR
      CUR=$(pfw)
    fi
    for i in $(xrdb -query colors | sort -V $opt | awk '{ print $2 }' | tr -d '#' )
    do
      cont=$((cont+1))
      chwb -c $i $(pfw) 
      sleep $FREQ
      case $cont in
        16)
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
