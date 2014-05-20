#!/bin/bash
cd $(dirname $0)
. ./config.sh

XEN_DOM0_CREDIT=${XEN_DOM0_WEIGHT:-256}

echo "Domain-0: setting weight to $XEN_DOM0_CREDIT"
$(which xl) sched-credit -d Domain-0 -w$XEN_DOM0_CREDIT

for cfg in $XEN_DOMU_START
do
  echo "== launching domU from file $cfg =="
  $(which xl) create $XEN_DOMU_CONFIG/$cfg 
done

