# sample service for systemd

## xen-VTD.service

  service to hide devices to dom0 host on boot
  (using "xen4-pciback" from top level)

## xen-platform.service

  service to start/stop internal bridges and domU

  (using "ovs-bridges-maker" and "xen4-launcher" from top level)


