# Pi-Timelapse
Timelapse system for my Raspberry Pi Zero2

I wanted a new timelapse system, using my Raspberry Pi Zero2 with a Waveshare Fisheye (160 degrees) camera module with 5 megapixel OV5647 sensor.
First I based it on Jeff Geerling's Python Pi-Timelapse, but later I decided that a shell script would do fine too.

The script is as straightforward as it can be. The numbering of the files is based on the number of seconds from midnight. In my specific usecase, I let it take
one picture every minute, starting around 5:00 (a bit later in winter) until 23:00.
When the photo's are taken, the Pi puts a line with 'Maashaven, Rotterdam' at the bottom left and the date/time at the bottom right.
The photo is stored in /tmp for speed, and after modification, it's put on my NAS share.

On the (Synology) NAS, there's a script that runs at 23:15 to compile a video of it. This is done on the NAS to offload the Pi. It's outside and the
WiFi is not perfect. And the Pi is not powerful enough to compile 1100+ 5MP photo's into a video with FFMPEG.
