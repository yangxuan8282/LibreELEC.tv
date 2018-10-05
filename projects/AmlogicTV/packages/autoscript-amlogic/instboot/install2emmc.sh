#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

IMAGE_KERNEL="/flash/kernel.img"
IMAGE_SYSTEM="/flash/SYSTEM"
SCRIPT_EMMC="/flash/emmc_autoscript"
SCRIPT_ENV="/flash/uEnv.ini"
IMAGE_DTB="/flash/dtb"

if [ -f $IMAGE_KERNEL -a -f $IMAGE_SYSTEM -a -f $SCRIPT_EMMC -a -f $SCRIPT_ENV ] ; then

    if grep -q /dev/system /proc/mounts ; then
      echo "Unmounting SYSTEM partiton."
      umount -f /dev/system
    fi
    e2label /dev/system "LE_EMMC"
    e2label /dev/data "DATA_EMMC"
    mkdir -p /tmp/system
    mount -o rw /dev/system /tmp/system

    if grep -q /dev/system /proc/mounts ; then

        cp $IMAGE_KERNEL /tmp/system && sync
        cp $IMAGE_SYSTEM /tmp/system && sync
        cp $SCRIPT_EMMC /tmp/system && sync
        cp $SCRIPT_ENV /tmp/system && sync
        sed -e "s/LIBREELEC/LE_EMMC/g" \
          -e "s/STORAGE/DATA_EMMC/g" \
          -i "/tmp/system/uEnv.ini"

        cp -r $IMAGE_DTB /tmp/system && sync

        umount /tmp/system
        sync
        poweroff
        exit 0
    else
      echo "No /dev/system  partiton."
      exit 1
    fi
else
    echo "No LE image found on /flash! Exiting..."
    exit 1
fi
