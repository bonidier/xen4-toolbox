#!/bin/bash
#
# author : Didier BONNEFOI <dbonnefoi@gmail.com>
#

[ -z "$BIN_OVS_VSCTL" ] && BIN_OVS_VSCTL=$(which ovs-vsctl)

# create a bridge in OVS
# usage : ovs_add_bridge <bridge>
function ovs_add_bridge 
{
  local ret=
  _log_debug "OVS: adding bridge $1"
  [ $# -lt 1 ] && echo "$_ERR_NO_BRIDGE_DEFINED" && return 1
  $BIN_OVS_VSCTL -- --may-exist add-br $1
  ret=$?
  _log_debug "ret ovs_add_bridge=$ret"
  return $ret
}

# remove a bridge from OVS
# usage : ovs_remove_bridge <bridge>
function ovs_remove_bridge 
{
  local ret=
  _log_debug "OVS: removing bridge $1"
  [ $# -lt 1 ] && echo "$_ERR_NO_BRIDGE_DEFINED" && return 1
  $BIN_OVS_VSCTL del-br $1
  ret=$?
  _log_debug "ret ovs_remove_bridge=$ret"
}

# return ports binded to specified bridge
# usage : ovs_bridge_list_ports <bridge>
function ovs_bridge_list_ports
{
    local brname=$1
    $BIN_OVS_VSCTL list-ports $brname

}

# add/remove bridges from host's OpenVSwitch
# usage : ovs_set_host_bridge start|stop
function ovs_set_host_bridge
{
  [ -z "$HOST_PETH" ] && echo "HOST_PETH not defined" && return 1
  [ -z "$HOST_BRIDGE" ] && echo "HOST_BRIDGE not defined" && return 1

  echo -e "\n== OVS : bridge's host $HOST_PETH/$HOST_BRIDGE ==\n"
  case $1 in
  start)

    _log_debug "adding NIC $PHY_ETH to bridge $HOST_BRIDGE"
    ovs_add_bridge $HOST_BRIDGE
    $BIN_OVS_VSCTL -- --may-exist add-port $HOST_BRIDGE $HOST_PETH

#    echo "OVS: removing OVS's ports on bridge $HOST_BRIDGE"
#    for p in $(ovs_bridge_list_ports $HOST_BRIDGE | grep -v $HOST_PETH);
#    do
#      echo "- removing port $p"
#      $BIN_OVS_VSCTL del-port $p
#    done
    ;;
  stop)
     ovs_remove_bridge $HOST_BRIDGE
    ;;
  *)
    echo "start|stop"
    ;;
  esac

  return 0

}

# add/remove VM's bridges from OpenVSwitch configuration
# usage : 
#  start : ovs_set_VM_bridge <mode> <vbrname> <vbrIP>
#  stop  : ovs_set_VM_bridge <mode> <vbrname>
#   mode : start|stop
#   vbrname : bridge name, like vbr.123
#   vbrIP : A.B.C.D (gateway for VM binded on this bridge)
function ovs_set_VM_bridge
{
  local mode=$1
  local vbrname=$2
  local vbrIP=$3

  [ "$vbrname" == "" ] && echo "vbrname missing" && return 1
  local rule_for_dhcp="-host 255.255.255.255 $vbrname"

  echo -e "\n== vbrname=$vbrname / vbrIP=$vbrIP ==\n"

  case $mode in
  start)
    [ "$vbrIP" == "" ] && echo "vbrIP missing" && return 1
    bridge_create $vbrname $vbrIP
    route add $rule_for_dhcp
    bridge_exists $vbrname && ovs_add_bridge $vbrname

    echo "OVS ports on bridge $vbrname"
    for p in $($BIN_OVS_VSCTL list-ports $vbrname)
    do
#      echo "- removing port $p"
#      $BIN_OVS_VSCTL del-port $p
      echo "- port $p present"
    done
    ;;
#  stop|forcestop)
   stop)
    local VMports=$(ovs_bridge_list_ports $vbrname)
    echo -e "VMports=\n"$VMports
    if [ "$VMports" == "" ]; then
      ovs_remove_bridge $vbrname
      bridge_delete $vbrname
    else
	  echo "opened ports or bad bridge"
	  # forcing system to delete bridge
	  #if [ "$mode" == "forcestop" ]; then
        #  ovs_remove_bridge $vbrname
        #  bridge_delete $vbrname
	  #fi
    fi
    ;;
  *)
    echo "start|stop"
    ;;
  esac
}

# wrapper to add/remove all configured  bridges
# usage : ovs_set_VM_bridges start|stop
function ovs_set_VM_bridges
{
  local mode=$1
  local br_conf=
  local vbrname=
  local vbrIP=
  [ -z "$BRIDGES_CONF" ] && echo "BRIDGES_CONF not defined" && return 1

  for br_conf in $BRIDGES_CONF
  do
    vbrname=$(echo $br_conf | cut -d'|' -f1)
    vbrIP=$(echo $br_conf | cut -d'|' -f2)
    ovs_set_VM_bridge $mode $vbrname $vbrIP
  done

}

# wrapper to show OVS configuration
function ovs_show
{
  $BIN_OVS_VSCTL show
}
