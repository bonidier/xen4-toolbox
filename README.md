# xen4-toolbox

## intro

this repository content my Xen utilities used on my personnal station

more details in each directory

## Tools

### ovs-bridges-maker

use Xen 4.x with Open vSwitch !

this library allow to start/stop many bridges with OpenVSwitch 'on the fly'
also include 'vif-openvswitch' script to bind your domU to OVS

### systemd-services

sample Systemd service to start my Xen platform, based on script in this other directories

### xen4-domUstarter

script to boot user defined DomU (VM), and stop all of them on shutdown

### xen4-pciback

script to hide device from Dom0 (Hypervisor)
this feature depends on your hardware-capabilities

example 
Keep linux as your main OS and : 
- forward USB controller, Soundcard, etc... to your domU (mouse, keyboard, phone update ?)
- Play your favourite games on Windows DomU with your real GPU !

### xenstore-dump

XenStore is an information storage space shared between domains
use a personal library for a more human-readable output



