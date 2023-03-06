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

I broke DASH but only for...the DASH reference player in my demo code and have no idea why.
VideoJS looks like a dece player for HLS.
https://videojs.com/guides and the [live streaming](https://github.com/videojs/http-streaming) script looks like it's all we need
Apple is evil but hey, I guess we're using HLS. DASH "doesn't work" on apple software like iOS. Cloudflare could be a start for the "do I need a CDN?" question.

https://www.cloudflare.com/learning/video/what-is-mpeg-dash/

scheduling software...minimal

https://github.com/TheOpponent/mr-otcs

Microsoft is doing video indexing with AI? that sounds silly.

https://github.com/microsoft/Video-Indexer-Processor
