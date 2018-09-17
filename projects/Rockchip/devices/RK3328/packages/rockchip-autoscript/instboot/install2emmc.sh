#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

IMAGE_KERNEL="/flash/KERNEL"
IMAGE_SYSTEM="/flash/SYSTEM"
IMAGE_DTB="/flash/dtb"
SCRIPT_EMMC="/flash/extlinux"

DEV_EMMC="/dev/mmcblk1"

install_to_emmc() {
  if [ -f $IMAGE_KERNEL -a -f $IMAGE_SYSTEM ] ; then

    mount -o rw,remount /flash

    if grep -q "${DEV_EMMC}p1" /proc/mounts ; then
        echo "Unmounting SYSTEM partiton."
        umount -f "${DEV_EMMC}p1"
    fi
    echo -n "Formatting SYSTEM partition..."
    mkfs.vfat -n "LE_EMMC" "${DEV_EMMC}p1"
    echo "done."

    mkdir -p /tmp/system
    mount "${DEV_EMMC}p1" /tmp/system

    if grep -q "${DEV_EMMC}p1" /proc/mounts ; then

        echo -n "Cppying kernel image..."
        cp $IMAGE_KERNEL /tmp/system && sync
        echo "done."

        echo -n "Copying SYSTEM files..."
        cp $IMAGE_SYSTEM /tmp/system && sync
        echo "done."

        echo -n "Writing device tree image..."
        cp -R $IMAGE_DTB /tmp/system && sync
        echo "done."

        echo -n "Writing script eMMC..."
        cp -R $SCRIPT_EMMC /tmp/system && sync
        sed -e "s/LIBREELEC/LE_EMMC/g" \
          -e "s/STORAGE/DATA_EMMC/g" \
          -i "/tmp/system/extlinux/extlinux.conf"
        echo "done."

        umount /tmp/system

	if grep -q "${DEV_EMMC}p2" /proc/mounts ; then
	    echo "Unmounting DATA partiton."
	    umount -f "${DEV_EMMC}p2"
	fi
	
	echo -n "Formatting DATA partition..."
        mkfs.ext4 -F -L DATA_EMMC "${DEV_EMMC}p2"
        e2fsck -n "${DEV_EMMC}p2"
	echo "done."
	
        mkdir -p /tmp/data
        echo "Mount DATA partition..."
        mount -o rw "${DEV_EMMC}p2" /tmp/data
	echo "" > /tmp/data/.please_resize_me
        umount /tmp/data

	sync

	echo "All done!"
        echo "WARNING: If your internal memory layout is different from standard Amlogic, you have to perform this operation again!"
        echo "Poweroff Your system, remove media will run from internal memory."
        echo ""

    else
      echo "No $DEV_EMMC partiton."
    fi

  else
    echo "No LE image found on /flash! Exiting..."
  fi
}

echo "This script will erase BOOT, SYSTEM, DATA and DTB on your device"
echo "and install LE that you booted from SD card/USB drive."
echo ""
echo "It will create a backup of bootloader on your boot media."
echo ""
echo "The script does not have any safeguards!"
echo ""

install_to_emmc
