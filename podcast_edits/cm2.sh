#!/bin/sh

# cut out 150 (in seconds) to the end of the file from an mp3
#usage: cm2.sh filename.mp3 150

file=$1
origFile=$1
time1=$2
time2=$3

TIMECALC2=`taginfo $file  |grep LENGTH | sed 's/LENGTH="//' | sed 's/"//'`

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
#ffmpeg -i $file -ss "$time2" -c copy $newfile2
ffmpeg -i $file -ss "$TIMECALC2" -c copy $newfile2

rm $file

ffmpeg -i "concat:$newfile1|$newfile2" -c copy $file
rm $newfile2
rm $newfile1
mv $file $origFile


#AMTCUT=$((time2-time1))
AMTCUT=$((TIMECALC2-time1))
MINUTES=`echo "scale=2 ; $AMTCUT / 60" | bc`
echo 'cut '$AMTCUT' seconds '$MINUTES' minutes'


file2=$origFile
fbname2=$(basename "$origFile" .mp3)
newfile2=$fbname2'_0.mp3'
mv $origFile $newfile2



