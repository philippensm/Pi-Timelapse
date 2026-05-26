#!/bin/bash
# /home/pi/timelapse.sh
# dependencies: only imagemagik

# Set some variables
# Mountpount of the NAS fileshare, homedirectory of the timelapse system on the NAS
NAS=/mnt/synas_share
# Day in format YYYYMMDD to assemble the foldername
DAY=$(date +%Y%m%d)
# Foldername
DIR="$NAS/timelapse-$DAY"
# Display date for the photo's
DISPLAY_DATE=$(LC_TIME=nl_NL.UTF-8 date '+%d-%b-%Y %H:%M')

# Sequencenumber = minutes since midnight (start at 05:00 = 300)
HOUR=$(date +%H)
MIN=$(date +%M)
SEQ=$(printf "%08d" $((10#$HOUR * 60 + 10#$MIN)))

#Tempfile where the photo is first stored
TMP=/tmp/shot_$$.jpg
# Output file on the NAS for ImageMagik
OUT="$DIR/image_${SEQ}.jpg"

# Check if the NAS share is mounted
mountpoint -q "$NAS" || exit 1
# Check if directory exists and/or create it
mkdir -p "$DIR"

# Take a photo and store it in the TMP dir
rpicam-still -n -t 500 \
  --width 2560 --height 1440 \
  --quality 95 \
  -o "$TMP"

# Put the Title text and date in the photo and store the output file on the NAS
# note that in newer versions of Imagemagick this might be calles magick instead of convert.
convert "$TMP" \
  -font DejaVu-Sans-Bold -pointsize 40 \
  -fill white -stroke black -strokewidth 2 \
  -gravity SouthWest -annotate +20+20 "Maashaven, Rotterdam-Zuid" \
  -gravity SouthEast -annotate +20+20 "$DISPLAY_DATE" \
  -quality 95 \
  "$OUT"

# Delete the tmpfile
rm -f "$TMP"
