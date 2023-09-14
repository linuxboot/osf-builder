#!/bin/bash
VPD="../../tools/vpd"
ROM="build/qemu-x86_64/coreboot/build/coreboot.rom"

#Or don't add '-O' that reformats the RO_VPD created by osf-builder/Makefile.inc
$VPD -f $ROM -O -i RO_VPD -s fsp_log_enable=0
$VPD -f $ROM -i RO_VPD -s systemboot_log_level=7
$VPD -f $ROM -O -i RW_VPD

