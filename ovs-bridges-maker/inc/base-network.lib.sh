#!/bin/bash
#
# author : Didier BONNEFOI <dbonnefoi@gmail.com>
#

_ERR_NO_BRIDGE_DEFINED="no bridge defined"

[ -z "$BIN_BRCTL" ] && BIN_BRCTL=/usr/sbin/brctl


# for verbose/debug informations
# usage : _log_debug "your_message"
function _log_debug
{
  [ "$_DEBUG_" == "1" ] && echo "[debug]: $1"
}

#
# usage : vlan_create <vlan_if> <vlan_id> <if_label>
#
function vlan_create
{
  local vlan_if=$1
  local vlan_id=$2
  local if_label=$3

  [ $# -ne 3 ] && echo "vlan_create <vlan_if> <vlan_id> <if_label>" >&2 && return 1

  ip link add link $vlan_if name $if_label type vlan id $vlan_id \
  &&
  ip link set dev $if_label up

  return $?

}

#
# function to add ip/network mask/broadcast to an IF
# if broadcast not set, will try to find it with ipcalc utility
#
# if_set_ip <if_label> <if_ip> [<broadcast>]
#
# if broadcast not set, will try to find it with ipcalc utility
#
function if_set_ip
{
   local if_label=$1
   local if_ip=$2
   local broadcast=$3

   [ $# -lt 2 ] && echo "if_set_ip <if_label> <if_ip> [<broadcast>]" && return 1

   # we calculate broadcast with ipcalc

   $(which ipcalc) >/dev/null 2>&1
   if [ $? -eq 0 ] ; then
      broadcast=$(ipcalc -bn $if_ip | grep Broadcast: | cut -d' ' -f2)
   else
      echo "ipcalc not found, using default broadcast" >&2
   fi
   [ -z "$broadcast" ] && broadcast=0.0.0.0

   echo "ip addr add $if_ip $str_bcast dev $if_label"
   ip addr add $if_ip brd $broadcast dev $if_label
   return $?
}


# usage : if_remove <ifname>
function if_remove
{
  local ifname=$1
  [ -z "$ifname" ] && return 1

  ip link set dev $ifname down \
  && 
  ip link delete $ifname

  return $?
}


##### Bridge Management #####

# check if bridge exists on OS
# usage : bridge_exists <bridge>
function bridge_exists
{
  local ret=
  [ $# -lt 1 ] && echo "$_ERR_NO_BRIDGE_DEFINED" && return 1
  $BIN_BRCTL show | grep ^$1 >/dev/null
  ret=$?
  _log_debug "ret bridge_exists=$ret"
  return $ret
}

# create a bridge on host system
# bridge_create <bridge> <IP>
function bridge_create
{
  [ $# -lt 2 ] && echo "$_ERR_NO_BRIDGE_DEFINED" && return 1
  local brname=$1
  local brIP=$2
  local ret=

  bridge_exists $vbrname 
  if [ $? -eq 0 ]; then
     _log_debug "bridge $brname already exists"
     ret=1
  else
    echo "creating bridge $brname :"
    $BIN_BRCTL addbr $brname \
    && ip link set $brname up \
    && if_set_ip $brname $brIP
    ret=$?
  fi
  _log_debug "ret bridge_create=$ret"

  return $ret
}

# remove a bridge from OS
# bridge_delete <bridge>
function bridge_delete
{
  [ $# -lt 1 ] && echo "$_ERR_NO_BRIDGE_DEFINED" && return 1
  local vbrname=$1
  local ret=

  bridge_exists $vbrname

  if [ $? -ne 0 ]; then
    echo "bridge [$vbrname] missing"
    ret=1
  else
    ip link set $vbrname down \
    && $BIN_BRCTL delbr $vbrname
    ret=$?
    _log_debug "bridge [$vbrname] removed"
  fi
  _log_debug "ret bridge_delete=$ret"
  return $ret
}

