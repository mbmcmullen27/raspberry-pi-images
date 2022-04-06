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
    Builds a custom raspiOs image using the latest release and a packer template 
    Execute without any options to update the template and build an image.

  OPTIONS:
    -b builds image from specified template defaults to templates/ssh-enabled.json
    -d download latest image as a zip
    -u takes optional path of template to update defaults to updating templates/*.json
    -v print latest available raspios image version
EOF
}

function Build() {
  if [[ ! -z $1 ]]; 
  then cp $1 raspios.json
  else cp templates/ssh-enabled.json raspios.json
  fi
  
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
  if [[ ! -z $1 ]]; then 
    UpdateTemplate $1
  else
    for f in templates/*.json; do
      UpdateTemplate $f
    done
  fi
}

function UpdateTemplate() {
  image=$url/$img/$file
  jq ".builders[0].file_urls[0]=\"$image\" | .builders[0].file_checksum_url=\"${image}.sha256\"" \
    $1 | sponge $1

}

function Version() {
  echo "$img"
}

optional_argument() {
  eval next_token=\${$OPTIND}
  if [[ -n $next_token && $next_token != -* ]]; then
    OPTIND=$((OPTIND + 1))
    OPTARG=$next_token
  else
    OPTARG=""
  fi
}

while getopts "hbdv:ub" option; do
   case "${option}" in
      h) # display Help
        Help
        exit;;
      b) # build template 
        optional_argument $@
        Build $OPTARG 
        exit;;
      d) # download latest image
        Download
        exit;;
      u) # update template
        optional_argument $@
        Update $OPTARG
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
