 #
 # Copyright � 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 #
#!/bin/bash
#TOOLCHAIN="/home/neo/android/toolchains/arm-eabi-4.4.3/bin/arm-eabi"
TOOLCHAIN="/home/neo/android/toolchains/arm-linux-androideabi-4.7/bin/arm-linux-androideabi"
MODULES_DIR="../modules"
ZIMAGE="/home/neo/android/kernels/latest/kernel/arch/arm/boot/zImage"
KERNEL_DIR="/home/neo/android/unpack"
MKBOOTIMG="/home/neo/android/unpack/mkbootimg"
MKBOOTFS="/home/neo/android/unpack/mkbootfs"

if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
rm $ZIMAGE
rm $MODULES_DIR/*
fi
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN- nicki_dwi_defconfig
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN- menuconfig
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN- -j3
if [ -a $ZIMAGE ];
then
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$TOOLCHAIN-strip --strip-unneeded *.ko
zip -9 modules *
cd $KERNEL_DIR
echo "Creating boot image"
#$MKBOOTFS ramdisk/ > $KERNEL_DIR/ramdisk.cpio
#cat $KERNEL_DIR/ramdisk.cpio | gzip > $KERNEL_DIR/root.fs
$MKBOOTIMG --kernel $ZIMAGE --ramdisk boot.img-ramdisk.cpio.gz --base 0x80200000 --cmdline 'panic=3 console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 androidboot.selinux=permissive msm_rtb.filter=0x3F ehci-hcd.park=3' --pagesize 4096 --ramdiskaddr 0x82200000 -o $KERNEL_DIR/boot_latest_$(date +%s).img
else
echo "Compilation failed! Fix the errors!"
fi

