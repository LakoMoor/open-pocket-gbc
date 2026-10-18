#!/usr/bin/env bash
# Grab one frame from the HDMI capture card: ./grab.sh out.png [delay_s]
FF=/e/tools/ffmpeg/ffmpeg-N-127617-g94cba3150c-win64-gpl/bin/ffmpeg.exe
DEV=$("$FF" -hide_banner -list_devices true -f dshow -i dummy 2>&1 | grep -o '"USB[23].0 U\?HD"' | head -1 | tr -d '"')
"$FF" -hide_banner -loglevel error -y -f dshow -video_size 1280x720 -i video="$DEV" -ss "${2:-1.5}" -frames:v 1 "$1"
