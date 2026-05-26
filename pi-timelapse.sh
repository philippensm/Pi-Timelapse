#!/bin/bash
# /home/pi/timelapse.sh
# dependencies: only imagemagik

NAS=/mnt/synas_share
DAY=$(date +%Y%m%d)
DIR="$NAS/timelapse-$DAY"
DISPLAY_DATE=$(LC_TIME=nl_NL.UTF-8 date '+%d-%b-%Y %H:%M')

# Volgnummer = minuten sinds middernacht (start om 05:00 = 300)
HOUR=$(date +%H)
MIN=$(date +%M)
SEQ=$(printf "%08d" $((10#$HOUR * 60 + 10#$MIN)))

TMP=/tmp/shot_$$.jpg
OUT="$DIR/image_${SEQ}.jpg"

mountpoint -q "$NAS" || exit 1
mkdir -p "$DIR"

rpicam-still -n -t 500 \
  --width 2560 --height 1440 \
  --quality 95 \
  -o "$TMP"

# note that in newer versions of Imagemagick this might be calles magick instead of convert.
convert "$TMP" \
  -font DejaVu-Sans-Bold -pointsize 40 \
  -fill white -stroke black -strokewidth 2 \
  -gravity SouthWest -annotate +20+20 "Maashaven, Rotterdam-Zuid" \
  -gravity SouthEast -annotate +20+20 "$DISPLAY_DATE" \
  -quality 95 \
  "$OUT"

rm -f "$TMP"
