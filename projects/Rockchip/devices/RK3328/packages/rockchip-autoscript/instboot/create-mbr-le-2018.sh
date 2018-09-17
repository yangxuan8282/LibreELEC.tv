#!/bin/sh

echo "Start script create MBR and filesystem"

DEV_EMMC=/dev/mmcblk1

echo "Start backup u-boot default"

mount -o rw,remount /flash

dd if="${DEV_EMMC}" of=/flash/u-boot-default.img bs=1M count=16

echo "Start create MBR and partittion"

if grep -q "${DEV_EMMC}p1" /proc/mounts ; then
    echo "Unmounting SYSTEM partiton."
    umount -f "${DEV_EMMC}p1"
fi

if grep -q "${DEV_EMMC}p2" /proc/mounts ; then
    echo "Unmounting DATA partiton."
    umount -f "${DEV_EMMC}p1"
fi

parted -s "${DEV_EMMC}" mklabel msdos
parted -s "${DEV_EMMC}" mkpart primary fat32 16M 532M
parted -s "${DEV_EMMC}" mkpart primary ext4 533M 565M

if [ -f /flash/uboot.img ] ; then
    echo "Start update u-boot"
    dd if=/flash/uboot.img of="${DEV_EMMC}" conv=fsync seek=16384
fi

sync

echo "Done"

exit 0
