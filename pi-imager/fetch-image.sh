#!/bin/bash
url="https://downloads.raspberrypi.org/raspios_lite_armhf/images/"
function fetch() {
    curl -s $1 |\
        grep -Po $2 |\
        sort -nr |\
        head -n1
} 

img=$(fetch $url "(?<=href=\")raspios[^\"/]*")
echo "The latest image build is: $img"
file=$(fetch $url$img/ "(?<=href=\")[^\./]*.zip")
echo "Downloading $file"
wget $url$img/$file