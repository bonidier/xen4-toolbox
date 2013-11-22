#!/usr/bin/env bash

cd $(dirname $0)
. ./xenstore-dumpkey.sh
. ./config.sh

[ -z "$KV2XML_PATH" -o ! -d "$KV2XML_PATH" ] && echo "KV2XML_PATH empty or bad directory" && exit 1

. ${KV2XML_PATH}/kv2xml.lib.sh

echo "<dump-xenstore>"
for key in $(xenstore-list / | egrep -v 'tool|libxl'); 
do
   # convert xenstore output to XML
   xenstore_dumpkey /${key} | kv2xml
done
echo "</dump-xenstore>"
