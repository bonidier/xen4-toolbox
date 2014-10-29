# Introduction 

This tools help you to unbind(hide) a pci device from dom0 and forward it to a Xen domU

# Requirement

your Motherboard+CPU need VT-d/IOMMU support

# Tree

  * bin/vtd-devices.sh : main script to bind all declared devices to pciback
  * bin/config.sh.dist : configuration file example for vtd-devices.sh
  * bin/BDFlspci.sh string : get BDF (Bus:Device:Function) id from pci-device string
  * bin/pciback.sh BDF : unbind a BDF set as first argument
  * bin/xlpci2name.sh : show xen PCI assignable BDF's devices names
  * ../systemd-services/xen-VTD.service : startup systemd script example to hide devices on boot


# process

for each device declared in your config.sh file :

 * vtd-devices.sh use BDFlspci.sh to get mapped BDF (if string found)
 * found BDF is passed as argument to pciback.sh


# Configuration

define a uniq string part of your device name as shown with lspci command, NewLine between each of them

create a ./bin/config.sh file like this : 

~~~
XEN_PCIBACK_HIDE_LIST="device1
device2
"
~~~

# Usage

./bin/vtd-devices.sh
