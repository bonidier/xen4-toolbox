#!/bin/bash

[ -f config.sh ] && . ./config.sh
[ "$BIN_XL" == "" ] && BIN_XL=/usr/sbin/xl

# we remove headers and get third column, with domU's name
VM_LIST=$($BIN_XL vm-list | tail -n+2 | awk '{print $3}')

echo -e "$0: domU to shutdown : \n$VM_LIST"
[ "$VM_LIST" == "" ] && echo "-- no domU launched --"

for vm in $VM_LIST
do
  echo "$0: shutting down domU  '$vm'"
  $BIN_XL shutdown -w $vm
  echo "$0: domU $vm : ret=$?"
done


