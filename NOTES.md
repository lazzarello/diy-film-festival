## Cathode setup, reversed circa mid 2022

Web Hosting: Squarespace
DNS: Squarespace
Streaming proxy service: restream.io
Streaming Video delivery: "Live with Restream" https://ok.ru/live/4450477350630
embedded is 
//ok.ru/videoembed/4450477350630

[Streamlink](https://github.com/streamlink/streamlink) is the opposite...takes input from streaming sites and outputs to VLC.

## Play a directory of files

The ffmpeg concat input demuxer has some pretty tight requirements...

All files must be the same codec and if they are not the same duration, it must be specified in the playlist. I don't think this is what I want.
