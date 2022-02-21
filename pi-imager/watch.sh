#!/bin/bash

let it=1
DIR='sd'
FOUND=false
sudo dmesg -C

while [ $FOUND == false ]; do
  disk=$(dmesg | egrep -o mmcblk[0-9])
  if [ -n "$disk" ]; then
    FOUND=true
    python write-line.py "sd card detected" 
    python write-line.py "writing image..." 2 
    mount /dev/$disk $DIR
    file=$(ls -1r imgs/ | head -n1)
    sudo dd if=imgs/$file of=/dev/$disk bs=4M conv=fsync
    umount /dev/$disk
  else
    str="sleeping"
    for k in $(eval echo "{1..$it}"); do
        str+="."
    done
    python write-line.py str  
    python write-line.py "                " 2 
    sleep 7
  fi
  let it++
  if [ $it -gt 2 ]; then let it=0; fi
done