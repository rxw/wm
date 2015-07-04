barid=$(xwininfo -name bar | awk 'NR==2 {print $4}')
echo $barid
