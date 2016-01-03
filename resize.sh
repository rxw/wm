case $2 in
  tb)
    sides=( top bottom )
    ;;
  *)
    sides=( left right )
    ;;
esac

for i in ${sides[@]}; do
  bspc config -d focused ${i}_padding $((`bspc config -d focused ${i}_padding` $1 20 ))
done
