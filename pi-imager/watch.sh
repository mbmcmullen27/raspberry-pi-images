#!/bin/bash

let it=1
DIR='sd'
FOUND=false
sudo dmesg -C

function write() {
  python write-lines.py $1 $2
}

while [ $FOUND == false ]; do
  disk=$(dmesg | egrep -o mmcblk[0-9])
  if [ -n "$disk" ]; then
    FOUND=true
    write "sd card detected" "writing image..."  
    # mount /dev/$disk $DIR
    file=$(ls -1r imgs/ | head -n1)
    sudo dd if=imgs/$file of=/dev/$disk bs=4M conv=fsync
    # umount /dev/$disk
  else
    str="sleeping"
    blankln=$(for i in {1..20}; do echo -n " "; done)
    for k in $(eval echo "{1..$it}"); do
        str+="."
    done
    write "$str" "$blankln" 
    sleep 7
  fi
  let it++
  if [ $it -gt 2 ]; then let it=0; fi
done