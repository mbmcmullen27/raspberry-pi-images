#!/bin/bash
url="https://downloads.raspberrypi.org/raspios_lite_armhf/images"

function Fetch() {
  curl -s $1 |\
    grep -Po "(?<=href=\")$2" |\
    sort -nr |\
    head -n1
} 

img=$(Fetch $url/ "raspios[^\"/]*")
file=$(Fetch $url/$img/ "[^\.]*.zip")

function Help() {
  cat <<EOF
  USAGE: 
      ./<scriptname> [-hbduv]

  DESCRIPTION:
    Builds a custom raspiOs image using the latest release and a packer template (./packer-template.json)
    Execute without any options to update the template and build an image.

  OPTIONS:
    -b builds image from current template
    -d download latest image as a zip
    -u update template with latest image version
    -v print latest available raspios image version
EOF
}

function Build() {
  [ ! -d "./imgs" ] && mkdir "imgs"
  sudo -E TMPDIR=/var/tmp packer build \
    -var "hostname=${PKR_HOSTNAME-'raspberrypi'}" \
    -var "ssid-name=$PKR_SSID" \
    -var "ssid-pass=$PKR_SSID_PASS" \
    raspios.json
}

function Download() {
  wget $url/$img/$file -P imgs/
}

function Update() {
  image=$url/$img/$file
  jq ".builders[0].file_urls[0]=\"$image\" | .builders[0].file_checksum_url=\"${image}.sha256\"" \
    packer-template.json > raspios.json
}

function Version() {
  echo "$img"
}

while getopts ":hbduv" option; do
   case "${option}" in
      h) # display Help
        Help
        exit;;
      b) # build template 
        Build 
        exit;;
      d) # download latest image
        Download
        exit;;
      u) # update template
        Update
        exit;;
      v) # print current version
        Version
        exit;;
      ?)
        echo "unsupported option $1"
        exit;;
   esac
done

if [ "$#" -eq 0 ]; then
  Update && Build
  exit 0;
fi



