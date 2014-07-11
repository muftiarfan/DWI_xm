#!/bin/bash
KERNEL_DIR=/home/neo/android/kernels/latest/kernel/
TOOLCHAIN="/home/neo/android/toolchains/arm-cortex_a15-linux-gnueabihf-linaro_4.8.3/bin/arm-cortex_a15-linux-gnueabihf"
obj-m := frandom.o
PWD := $(shell pwd)
default:
	$(MAKE) ARCH=arm CROSS_COMPILE=$TOOLCHAIN- -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules
clean:
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) clean
