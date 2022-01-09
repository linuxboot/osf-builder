#
# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

ARCH ?= $(shell uname -m)
ifneq ($(ARCH), $(shell uname -m))
CROSS_COMPILING := 1
else
CROSS_COMPILING := 0
endif

ifeq ($(ARCH), aarch64)
COREBOOT_TOOLCHAIN_ARCH := aarch64
LINUX_ARCH := arm64
LINUX_GCC_TUPLE := $(ARCH)-linux-
LINUX_IMAGE_RELATIVE_PATH := arch/arm64/boot/Image.gz
GOARCH := arm64
PLATFORM := qemu-$(ARCH)
QEMU_SYSTEM := qemu-system-$(ARCH)
endif
ifeq ($(ARCH), ppc64le)
COREBOOT_TOOLCHAIN_ARCH=$(ARCH)
GOARCH := $(ARCH)
LINUX_ARCH := powerpc
LINUX_IMAGE_RELATIVE_PATH := arch/powerpc/boot/zImage
LINUX_GCC_TUPLE := powerpc64-linux-gnu-
PLATFORM := qemu-$(ARCH)
QEMU_SYSTEM := qemu-system-$(ARCH)
endif
ifeq ($(ARCH), x86_64)
COREBOOT_TOOLCHAIN_ARCH := i386
LINUX_ARCH := $(ARCH)
LINUX_GCC_TUPLE := $(ARCH)-linux-
LINUX_IMAGE_RELATIVE_PATH := arch/x86/boot/bzImage
GOARCH := amd64
PLATFORM := qemu-amd64
QEMU_SYSTEM := qemu-system-$(ARCH)
endif

OSF_BUILDER_DIR := ../..

# CONFIG, KERNEL_CONFIG and COREBOOT_CONFIG are derived from CONFIGS_DIR and PLATFORM.
CONFIGS_DIR := ./configs
PATCHES_DIR := ./patches

include $(OSF_BUILDER_DIR)/Makefile.inc
OUT ?= build/$(PLATFORM)/osf-$(PLATFORM).rom

# RNG to avoid DHCP lockups when waiting for entropy
# redirect all the output to the console
QEMU_COMMON_OPTS := -bios $(OUT) $(QEMU_KVM_OPTS) \
	-m 1024 \
	-object rng-random,filename=/dev/urandom,id=rng0 \
	-nographic

run:
ifeq ($(ARCH), aarch64)
	$(QEMU_SYSTEM) $(QEMU_COMMON_OPTS) \
	-M virt,secure=on,virtualization=on \
	-cpu cortex-a53
endif
ifeq ($(ARCH), ppc64le)
	$(QEMU_SYSTEM) $(QEMU_COMMON_OPTS) \
	-M powernv,hb-mode=on \
	-cpu power9 \
	-drive file=build/coreboot.rom,if=mtd \
	-serial stdio \
	-display none
endif
ifeq ($(ARCH), x86_64)
	$(QEMU_SYSTEM) $(QEMU_COMMON_OPTS) \
	-M q35
endif
