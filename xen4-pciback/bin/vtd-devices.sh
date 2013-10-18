#!/bin/bash
[ $UID -ne 0 ] && echo "should be executed under root..." && exit 1
cd $(dirname $0)
[ -f config.sh ] && . ./config.sh

IFS=$'\n'

for d in $XEN_PCIBACK_HIDE_LIST
do
  #get BDF id
  BDF=$(./BDFlspci.sh "$d")
  echo "[device label : $d ]"
  echo "[device BDF(s) : $BDF]"
  #unbind BDF from dom0, forward to xen pciback
  ./pciback.sh $BDF
done

