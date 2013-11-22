#!/bin/bash
cd $(dirname $0)
. ./config.sh

for cfg in $XEN_DOMU_START
do
  echo "== launching domU from file $cfg =="
  $(which xl) create $XEN_DOMU_CONFIG/$cfg 
done

