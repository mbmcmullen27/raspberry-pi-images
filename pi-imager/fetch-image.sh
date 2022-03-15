#!/bin/bash

url="https://downloads.raspberrypi.org/raspios_lite_armhf/images"
function fetch() {
    curl -s $1 |\
        grep -Po "(?<=href=\")$2" |\
        sort -nr |\
        head -n1
} 

img=$(fetch $url/ "raspios[^\"/]*")
file=$(fetch $url/$img/ "[^\.]*.zip")

echo "The latest image build is: $img"

# wget $url/$img/$file -P imgs/
image=$url/$img/$file
jq ".builders[0].file_urls[0]=\"$image\" | .builders[0].file_checksum_url=\"${image}.sha256\"" \
  packer-template.json > raspios.json
