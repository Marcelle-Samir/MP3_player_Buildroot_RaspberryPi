# mp3 player (music box) 

using RaspberryPi 3 B+, customized Buildroot image, \
you can control your music player through 4 mechanical push buttons:
>pause/play button\
>shuffle button\
>previous button\
>next button

or by typing on terminal:
>Play
>pause
>next
>previous
>shuffle

the voice can be over:
>bluetooth speakers (to connect type connect on the terminal) \
>HDMI\
>wired speakers

Note: bluetooth speaker is highest priority and wired speaker is the lowest you can chane the priority by editing output_selector.sh script.

you can access RaspberryPi terminal through 
>Ethernet\
>WIFI\
>HDMI\
>UART

## Buildroot source
- you can download a clean repo from:
http://git.buildroot.net/buildroot/ 

## Navigate and do basic configuration

Apply the default configuration for our raspberry pi:
>make raspberrypi3_defconfig

To view and edit the configuration one by one we will use the menuconfig:
>make menuconfig

- We need to add support for ssh in our image

<img src="images/openssh.png" width="500">

You can start the build simply by typing make command, or to collect some information about our build in order to use them later for debugging if the build failed use:
>time make 2>&1 | tee build.log

