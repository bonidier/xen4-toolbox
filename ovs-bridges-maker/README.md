# intro

this library allow to start/stop many bridges with OpenVSwitch 'on the fly'
when stopping, if a VM is running on a bridge, this last will not be destroyed


#Requirement 

packages : 
- openvswitch
- dhcpd, pre-configured to listen on bridges that this script manage


# misc/xen/vif-openvswitch

script used by Xen to bind domU to OVS

- you should copy this script into /etc/xen/scripts/

- alter /etc/xen/xl.conf to change default vif script
 
    #default vif script 
    #vifscript="vif-bridge"
    vifscript="/etc/xen/scripts/vif-openvswitch"



# ovs-bridged-network.sh

start/stop script

# config.sh 

    # physical NIC to bind bridges
    HOST_PETH=eth0
    # dom0 main bridge name (you'll may also put your VM on your main network)
    HOST_BRIDGE=xbr
    
    # dom0 bridges for domUs (alternative networks)
    # format : alias | ip for bridge gateway
    BRIDGES_CONF="
    vbr.10|192.168.10.254
    vbr.11|192.168.11.254
    vbr.172|172.16.0.254
    "
    # you can override these binary paths, here are defaults values
    #BIN_IFCFG=/sbin/ifconfig
    #BIN_BRCTL=/usr/sbin/brctl
    #BIN_OVS_VSCTL=/usr/bin/ovs-vsctl

# ipt-masquerade.sh

this script display an *iptables* configuration to allow incoming/outgoing flow to VM on configured bridges



