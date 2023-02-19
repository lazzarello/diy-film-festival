# custom backend notes from my computer

Source: OBS, authentication via token over TLS
Transcoder/broadcast relay: ffmpeg (working as a one-to-many encoding proxy like restream.io)
Broadcast server: Nginx with RTMP module, authentication is IP based, which means the middle part is more important now

Questions:
  the proxy auth sounds important, how do we do that?
  Is authentication even important? probably if this is released to public viewers, regardless how unpopular they are
  
sent source to server
ffmpeg -re -i "VALIE-EXPORT_Syntagma_1983.mp4" -c:v copy -c:a aac -ar 44100 -ac 1 -f flv rtmp://35.209.252.86/live/stream
ffmpeg -re -stream_loop -1 -i "VALIE-EXPORT_Syntagma_1983.mp4" -c:v copy -c:a aac -ar 44100 -ac 1 -f flv rtmp://35.209.252.86/live/stream

File type based wildcards, not ideal

make a playlist (escape characters?) and stream that playlist
a playlist is a the word `file` followed by a path to a video file. if there are many with different codecs, ffmpeg will break when streaming to rtmp and the bitrate/codec changes

ffmpeg -f concat -safe 0 -stream_loop -1 -i "playlist.txt" -c:v copy -c:a aac -ar 44100 -ac 1 -f flv rtmp://35.209.252.86/live/stream

playback source after configuring DASH and HLS
http://35.209.252.86:8088/dash/stream.mpd
http://35.209.252.86:8088/hls/stream.m3u8

streaming transcoding, which might be useful
https://stackoverflow.com/questions/4556867/how-do-i-use-piping-with-ffmpeg
