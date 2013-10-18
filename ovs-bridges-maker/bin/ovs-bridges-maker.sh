#!/bin/bash
#
# author : Didier BONNEFOI <dbonnefoi@gmail.com>
#

curdir=$(dirname $0)/../
. $curdir/inc/base-network.lib.sh
. $curdir/inc/bridge-OVS.lib.sh
. $curdir/etc/config.sh

function ovs_status
{
  echo -n "OVS status : "
  pidof ovs-vswitchd >/dev/null && pidof ovsdb-server >/dev/null
  [ $? -ne 0 ] && echo "OFF"  && exit
  echo "ON"
}

function dhcpd_launcher
{
  echo -e "\n== DHCP service : $1 ==\n"
  pidof dhcpd
  local has_pid=$?
  local str_comm=$(cat /proc/1/comm 2>/dev/null)

  case $1 in
    start)
      # dhcpd already launched
      [ $has_pid -eq 0 ] && return
      [ "$str_comm" != "systemd" ] && /etc/init.d/dhcp4 start
      [ "$str_comm" == "systemd" ] && systemctl start dhcpd4
      ;;
    stop)
      # dhcpd already stopped
      [ $has_pid -eq 1 ] && return
      [ "$str_comm" != "systemd" ] && /etc/init.d/dhcp4 stop
      [ "$str_comm" == "systemd" ] && systemctl stop dhcpd4
      ;;
   *)
      echo "bad mode"
      ;;
  esac
}

ovs_status

mode=$1
case "$mode" in
  start)
    ovs_set_host_bridge $mode
    ovs_set_VM_bridges $mode
    dhcpd_launcher $mode
    ;;
  stop)
    ovs_set_host_bridge $mode
    ovs_set_VM_bridges $mode
    dhcpd_launcher $mode
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    echo -e "\n== OS : bridges show =="
    brctl show
    echo -e "\n== OVS : configuration show =="
    ovs_show
    ;;
  *)
    echo "usage: $0 start|stop|restart|status"
    ;;
esac
