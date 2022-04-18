#!/bin/bash
[ -z $LOCAL_BUILD ] && LOCAL_BUILD=false || LOCAL_BUILD=true

url="https://downloads.raspberrypi.org/raspios_lite_armhf/images"

function Fetch() {
  curl -s $1 |\
    grep -Po "(?<=href=\")$2" |\
    sort -nr |\
    head -n1
} 

img=$(Fetch $url/ "raspios[^\"/]*")
file=$(Fetch "$url/$img/" "[^\.]*\.img\.(zip|xz)")

function Help() {
  cat <<EOF
  USAGE: 
      ./<scriptname> [-hbduv]

  DESCRIPTION:
    Builds a custom raspiOs image using the latest release and a packer template 
    Execute without any options to update the template and build an image.

  OPTIONS:
    -b builds image from specified template, defaults to templates/ssh-enabled.json
    -d download latest image as a zip
    -u takes optional path of template to update, defaults to templates/*.json
    -v print latest available raspios image version
EOF
}

function Build() {
  if [[ -f "templates/$1.json" ]]; 
  then cp templates/$1.json raspios.json
  else cp templates/ssh-enabled.json raspios.json
  fi

  if [ $LOCAL_BUILD != true ]; then
     docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build raspios.json
  else 
    sudo -E TMPDIR=/var/tmp packer build \
      -var "hostname=${PKR_HOSTNAME-'raspberrypi'}" \
      -var "ssid-name=$PKR_SSID" \
      -var "ssid-pass=$PKR_SSID_PASS" \
      raspios.json
  fi
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
  if [[ ! -f "$1" ]];
    then echo "No such template: $1" >&2
    exit 1
  fi 

  image=$url/$img/$file
  ext=${file##*.}

  jq ".builders[0].file_urls[0]=\"$image\" | .builders[0].file_checksum_url=\"${image}.sha256\" | .builders[0].file_target_extension =\"${ext}\"" \
    $1 | sponge $1

  if [ "$ext" = "xz" ]; then 
    jq '.builders[0] |= if has("file_unarchive_cmd") then .file_unarchive_cmd=["xz", "-d", "$ARCHIVE_PATH"] else . += {"file_unarchive_cmd":["xz", "-d", "$ARCHIVE_PATH"]} end' $1 | sponge $1
  elif [ "$ext" = "zip" ]; then
    jq '.builders[0].file_unarchive_cmd+=["tar", "-xf", "$ARCHIVE_PATH"]' $1 | sponge $1
  fi

  echo "Updated $1"
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

while getopts "hbdvub" option; do
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
