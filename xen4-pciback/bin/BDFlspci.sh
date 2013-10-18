#!/bin/sh

desc=$1
[ "$desc" == "" ] && desc="NOTHING"
devices=$(lspci | grep "$desc" | awk '{print $1}')
BDF=
# for each devices found, construct BDF list (for ex, a PCI device like GPU can use many subdevices)
for d in $devices
do
  BDF="$BDF 0000:$d"
done
echo $BDF


