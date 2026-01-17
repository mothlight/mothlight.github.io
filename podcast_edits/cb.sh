#!/bin/sh

# cut out from the beginning of a file to 150 (in seconds) from an mp3
#usage: cb.sh filename.mp3 150

extra=$3
if [[ "$3" != '' ]]
then
  echo 'meant to use cm?'
  exit 1
fi

file=$1
time=$2
fbname=$(basename "$1" .mp3)
newfile=$fbname'_0.mp3'
ffmpeg -ss $time -i $file -c copy $newfile
rm $file

MINUTES=`echo "scale=2 ; $time / 60" | bc`
echo 'cut '$2' seconds '$MINUTES' minutes'
