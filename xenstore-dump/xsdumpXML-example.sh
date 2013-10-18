#!/usr/bin/env bash

. ./xenstore-dumpkey.sh
# you can get kv2xml from my repo https://github.com/bonidier/bodi-bashlib
. ../../bodi-bashlib/lib/kv2xml/kv2xml.lib.sh

_KV2XML_SEP_PATH="/"
_KV2XML_SEP_KV="="

echo "<dump-xenstore>"
for key in $(xenstore-list / | egrep -v 'tool|libxl'); 
do
   # convert xenstore output to XML
   xenstore_dumpkey /${key} | kv2xml
done
echo "</dump-xenstore>"
