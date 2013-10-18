This tools help you to unbind(hide) a pci device from dom0 and forward it to a Xen domU

requirement : your Motherboard+CPU need VT-d/IOMMU support

* bin/BDFlspci.sh : get BDF (Bus:Device:Function) id from pci-device string
* bin/pciback.sh : unbind a BDF passed to first argument
* bin/vtd-devices.sh : usage example
* ../systemd-services/xen-VTD.service : startup systemd script example, to hide your devices on boot

usage : 

    BDF=$(./BDFlspci.sh "Your_pci_device_to_ignore_from_dom0")
    ./pciback.sh $BDF
