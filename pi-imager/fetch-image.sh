#!/bin/bash
url="https://downloads.raspberrypi.org/raspios_lite_armhf/images/"
function fetch() {
    curl -s $1 |\
        grep -Po $2 |\
        sort -nr |\
        head -n1
} 

img=$(fetch $url "(?<=href=\")raspios[^\"/]*")
file=$(fetch $url$img/ "(?<=href=\")[^\./]*.zip")

echo "The latest image build is: $img"
echo "Downloading $file"

wget $url$img/$file