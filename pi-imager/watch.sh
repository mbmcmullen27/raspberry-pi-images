#!/bin/bash

let it=1
DIR='sd'
FOUND=false
sudo dmesg -C

while [ $FOUND == false ]; do
  disk=$(dmesg | egrep -o mmcblk[0-9])
  if [ -n "$disk" ]; then
    FOUND=true
    python write-lines.py "sd card detected" "writing image..."  
    mount /dev/$disk $DIR
    file=$(ls -1r imgs/ | head -n1)
    sudo dd if=imgs/$file of=/dev/$disk bs=4M conv=fsync
    umount /dev/$disk
  else
    str="sleeping"
    for k in $(eval echo "{1..$it}"); do
        str+="."
    done
    python write-lines.py str "                " 
    sleep 7
  fi
  let it++
  if [ $it -gt 2 ]; then let it=0; fi
done