#!/bin/bash
# Get today's date (format: YYYYMMDD)
VID=$(date +%Y%m%d)
DATUMTEKST=$(date +%d-%m-%Y)
# Base dir where the relevante folders are
BASE_DIR="/volume1/taart"
# Select random audiotrack (there are 8 tracks available)
number=$(( RANDOM % 8 + 1 ))
AUDIOFILE="${BASE_DIR}/audio/audiotrack$number.mp3"
# Assemble the full path for the photo's and the video
DIR="${BASE_DIR}/timelapse-${VID}"
VDIR="${BASE_DIR}/timelapse-videos"
TMPDIR="/volumeUSB1/usbshare/tmp" # tmpdir on the SSD of my NAS. Seems faster to me
# Check if todays' folder exists and create the video
if [ -d "$DIR" ]; then
    # go to the working folder
    cd "$DIR"
    
    # Calculate the length of the video for the fade-out of the music
    # Count the number of photo's in the folder
    AANTAL_FOTOS=$(ls -1 image_*.jpg 2>/dev/null | wc -l)
    # Calculate the length of the video in seconds (number of photo's / 30 fps)
    VIDEO_LENGTE=$(( AANTAL_FOTOS / 30 ))
    # Decide when the fade-out has to start (5 seconds before the end)
    FADE_START=$(( VIDEO_LENGTE - 5 ))
    # Safety check to prevent negative numbers when the video is very short for some reason
    if [ "$FADE_START" -lt 0 ]; then
        FADE_START=0
    fi

    # FFMPEG command with -shortest and dynamic -af (audio filter) for the fade-out
    # Split in two parts, because the NAS choked in it and the FFMPEG command looped
    # Make videofile without audio
    /usr/local/bin/ffmpeg7 -framerate 30 -pattern_type glob -i "${DIR}/image_*.jpg" -c:v libx264 -vf "scale=out_range=tv:in_range=pc,format=yuv420p" -crf 24 -color_range tv -movflags +faststart "${TMPDIR}/${VID}.mp4"
    #/usr/local/bin/ffmpeg7 -framerate 30 -i "${DIR}/image_%08d.jpg" -c:v libx264 -vf "scale=out_range=tv:in_range=pc,format=yuv420p" -crf 24 -color_range tv -movflags +faststart "${TMPDIR}/${VID}.mp4"
    # Add audio 
    /usr/local/bin/ffmpeg7 -i "${TMPDIR}/${VID}.mp4" -i "${AUDIOFILE}" -c:v copy -c:a aac -shortest -af "afade=t=out:st=${FADE_START}:d=5" -b:a 128k "${VDIR}/${VID}.mp4" 
else
    echo "Error: Folder ${DIR} not found. Task aborted."
fi
#    Upload to YouTube ---
    # Delete tmpfile
    rm "${TMPDIR}/${VID}.mp4"
    echo "Start YouTube upload..."
    # Path to the uploader folder with program and keys
    YT_DIR="/volume1/taart/uploader"
    
    # Title and description of the video
    YT_TITLE="Timelapse van Maashaven, Rotterdam Zuid (${DATUMTEKST})"
    YT_DESC="Uitzicht over Maashaven vanaf de Queen of the South (20ste verdieping). Gemaakt op ${DATUMTEKST} met een Raspberry Pi Zero2 W en een Pi-Cam."
    
    # Execute the uploader
    # -privacy public (of private / unlisted)
    # -categoryId 22 (People & Blogs - of kies een andere)
    ${YT_DIR}/youtubeuploader -filename "${VDIR}/${VID}.mp4" -title "${YT_TITLE}" -description "${YT_DESC}" -privacy public -secrets "${YT_DIR}/client_secrets.json" -cache "${YT_DIR}/request.token"
    echo "Upload voltooid!"
