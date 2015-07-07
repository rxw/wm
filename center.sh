#!/bin/sh

# get current window id, width and height
WID=$(pfw)
WW=$(wattr w $WID)
WH=$(wattr h $WID)

# get screen width and height
ROOT=$(lsw -r)
SW=$(wattr w $ROOT)
SH=$(wattr h $ROOT)

# move the current window to the center of the screen
case $1 in
  center) 
    wtp $(((SW - WW)/2)) $(((SH - WH)/2)) $WW $WH $WID
    ;;
  ltc)
    wtp 50 50 $WW $WH $WID
    ;;
  rtc)
    wtp $(((SW-50)-WW)) 50 $WW $WH $WID
    ;;
  lbc)
    wtp 50 $(((SH-50)-WH)) $WW $WH $WID
    ;;
  rbc)
    wtp $(((SW-50)-WW)) $(((SH-50)-WH)) $WW $WH $WID
    ;;
esac

