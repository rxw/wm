while :;
do
  eval $(xdotool getmouselocation --shell)
  for i in $(lsw)
  do
    if [ $X -gt $(wattr x $i) ] && [ $Y -gt $(wattr y $i) ]\
      && [ $X -lt $(($(wattr x $i) + $(wattr w $i))) ]\
      && [ $Y -lt $(($(wattr y $i) + $(wattr h $i))) ] \
      && ([ $X -lt $(wattr x $(pfw)) ]\
      || [ $X -gt $(($(wattr x $(pfw)) + $(wattr w $(pfw)))) ]\
      || [ $Y -lt $(wattr y $(pfw)) ]\
      || [ $Y -gt $(($(wattr y $(pfw)) + $(wattr h $(pfw)))) ]);
    then
      if [ $i != $(pfw) ]
      then
        sh ~/wm/focus.sh $i
      fi
    fi
  done
  sleep .2
done
