#!/bin/bash
lst_pciback=$(sudo xl pci-assignable-list)

for bdf in $lst_pciback
do
lspci -s $bdf
done
