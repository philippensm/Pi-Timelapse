# Pi-Timelapse
Timelapse system for my Raspberry Pi Zero2

I wanted a new timelapse system, using my Raspberry Pi Zero2 with a Waveshare Fisheye (160 degrees) camera module with 5 megapixel OV5647 sensor.
First I based it on Jeff Geerling's Python Pi-Timelapse, but later I decided that a shell script would do fine too.

This timelaps system is based on a 2 stage system: 
* the Pi is only used to take the photo's and store them on a file share (on a Synology NAS) between 05:00-23:00
* The NAS is used to create the video every day at 23:15
* The NAS also copies 3 photos each day around noon (12:00) to a seperate folder to create a year-timelapse

The BASH-script for the Pi is as straightforward as it can be. The numbering of the files is based on the number of seconds from midnight. 
In my specific usecase, I let it take one picture every minute, starting around 5:00 (a bit later in winter) until 23:00.
When the photo's are taken, the Pi puts a line with 'Maashaven, Rotterdam' at the bottom left and the date/time at the bottom right.
The photo is stored in /tmp for speed, and after modification qith ImageMagik, it's put on my NAS share.

On the (Synology) NAS, there's a script that runs at 23:15 to compile a video of it. This is done on the NAS to offload the Pi. It's outside and the
WiFi is not perfect. And the Pi Zero is not powerful enough to compile 1100+ 5MP photo's into a video with FFMPEG. You'd have to download the photo's
anyway or you'd have to add more storage. The Zero is not made for that and this way, the system remains compact.
