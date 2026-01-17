#!/bin/sh

# cut out from 122 to 150 (in seconds) from an mp3
#usage: cm.sh filename.mp3 122 150

file=$1
time1=$2
time2=$3
if [[ "$3" == '' ]]
then
  echo 'need ending time'
  exit 1
fi
newfile=$1'_X.mp3'

fbname=$(basename "$1" .mp3)
newfile1=$fbname'_1.mp3'
newfile2=$fbname'_2.mp3'




fbname=$(basename "$1" .mp3)
length=${#fbname}
lenUnder=$(( (($length)) -2 ))
lenNumber=$(( (($length)) -1 ))
under=${fbname:(($lenUnder)):1}
number=${fbname:(($lenNumber)):1}
if [[ "$under" == '_' ]]
then
  #newfile1=$fbname'_2.mp3'
  #newfile2=$fbname'_3.mp3'
  echo 'under'
  echo $number
  nextNumber=$(( (($number))  ))
  nextNumber2=$(( (($number)) +1 ))
  subname=${fbname:0:(($lenUnder))}
  newfile1=$subname'_'$nextNumber'.mp3'
  newfile2=$subname'_'$nextNumber2'.mp3'
else
  echo 'not'
  newfile1=$fbname'_1.mp3'
  newfile2=$fbname'_2.mp3'
fi


tmpfile='tmp'$file
mv $file $tmpfile
file=$tmpfile


ffmpeg -i $file -t "$time1" -c copy $newfile1
ffmpeg -i $file -ss "$time2" -c copy $newfile2
#echo "file 'part1.mp3'" > filelist;
#echo "file 'part2.mp3'" >> filelist;
#wait;
#ffmpeg -f concat -i filelist -c copy $newfile;
#rm filelist;
#rm part1.mp3;
#rm part2.mp3;
rm $file

AMTCUT=$((time2-time1))
MINUTES=`echo "scale=2 ; $AMTCUT / 60" | bc`
echo 'cut '$AMTCUT' seconds '$MINUTES' minutes'

