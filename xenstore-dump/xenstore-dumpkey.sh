# based on http://wiki.xen.org/wiki/XenStore #
function xenstore_dumpkey() {
   local param=${1}
   local key
   local result
   result=$(xenstore-list ${param})

   if [ "${result}" != "" ] ; then
     for key in ${result} ; do xenstore_dumpkey ${param}/${key} ; done
   else
     echo -n ${param}'='
     xenstore-read ${param}
   fi
}

