#!/bin/bash

let i=1
END=false

while [ $END == false ]; do
#   echo -n "sleeping"
#   eval printf '.%.0s' {0..$i}
#   echo ""

  str="sleeping" 
  for k in $(eval echo "{1..$i}"); do
    str+="."
  done
  echo $str

  sleep 1

  let i++
  if [ $i -gt 3 ]; then let i=1; fi
done
