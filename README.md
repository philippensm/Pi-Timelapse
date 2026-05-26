# Pi-Timelapse
Timelapse system for my Raspberry Pi Zero2

I wanted a new timelapse system, using my Raspberry Pi Zero2 with a Waveshare Fisheye (160 degrees) camera module with 5 megapixel OV5647 sensor.
First I based it on Jeff Geerling's Python Pi-Timelapse, but later I decided that a shell script would do fine too.

This timelaps system is based on a 2 stage system: 
* the Pi is only used to take the photo's and store them on a file share (on a Synology NAS) between 05:00-23:00
* The NAS is used to create the video every day at 23:15
* The NAS also copies 3 photos each day around noon (12:00) to a seperate folder to create a year-timelapse
* When the video is finished, it is uploaded to YouTube, using the Youtube Uploader

The BASH-script for the Pi is as straightforward as it can be. The numbering of the files is based on the number of seconds from midnight. 
In my specific usecase, I let it take one picture every minute, starting around 5:00 (a bit later in winter) until 23:00.
When the photo's are taken, the Pi puts a line with 'Maashaven, Rotterdam' at the bottom left and the date/time at the bottom right.
The photo is stored in /tmp for speed, and after modification qith ImageMagik, it's put on my NAS share.

On the (Synology) NAS, there's a script that runs at 23:15 to compile a video of it. This is done on the NAS to offload the Pi. It's outside and the
WiFi is not perfect. And the Pi Zero is not powerful enough to compile 1100+ 5MP photo's into a video with FFMPEG. You'd have to download the photo's
anyway or you'd have to add more storage. The Zero is not made for that and this way, the system remains compact.

The video gets a random soundtrack (from the 8 I have downloaded from the YouTube library) that fades out automatically 5 seconds before the end of
the video. It then is uploaded to YouTube with the YouTube Uploader. If you want to use the YouTube Uploader, you'll have to get a security token.
It's beyond the scope of this project to explain all that. I'll give some hints to get you started:
* Create a project in the Google Cloud Console
* Turn on the YouTube Data API
* You generate an OAuth 2.0-client-ID (this is a small .json file with a secret key)

If you use a Synology NAS like me, you have to do some trickery
You can use this YouTube Uploader program: https://github.com/porjo/youtubeuploader/releases
This repo contains the official YouTube Uploader for various systems. I need the Linux version for the Synology, but first I have to upload a test-video
using somthing my desktop computer can run (MacOS in my case). You can't use the Synology yet. You upload the test video with your desktop. Because it's 
the first time you use it, it'll open a browser window and after you login with your YouTube account, and allow it to run, you get a request.token. Together
with the .json file, this is the key you need to upload files to YouTube.
Put the request.token and the keys.json in the same directory as you YouTube Uploader on the Synology and you should be good to go. But you need to find 
a proper guide with all the steps. I just gave the rought outline.
Also note: when you do the test-upload, the application you created for YouTube is in testmode. When all is set, you should put the status to production, because
it will stop working after 5 days. That is considered your test period. You don't need to generate new key, but just put it in production mode and you're good.
