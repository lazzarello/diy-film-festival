#! /bin/bash

playlist_path="/home/lee/Videos/ubuweb/playlist.txt"
# video_transcoding_options="-c:v h264" # a valid ffmpeg list of transcoding options. can be
video_transcoding_options="-c:v libx264 -crf 18 -preset ultrafast -maxrate 1500k -bufsize 8000k -vf scale=1280:-1,format=yuv420p" # a valid ffmpeg list of transcoding options. can be
					# "-c:v copy" for pass-throughnotably, copy doesn't
                                        # work good for playlists of random files
audio_transcoding_options="-c:a aac -ar 44100 -ac 2" # audio transcoding options
                             # codec, sample rate, channels
rtmp_url="rtmp://35.209.252.86/live/stream"

# why does this race to the end of my CPU when run as a script?
ffmpeg -f concat \
   -safe 0 \
   -stream_loop -1 \
   -i "${playlist_path}" \
   ${video_transcoding_options} \
   ${audio_transcoding_options} \
   -f flv \
   $rtmp_url
