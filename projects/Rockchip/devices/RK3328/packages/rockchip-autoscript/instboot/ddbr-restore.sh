#!/bin/sh

image="EMMC-backup.img.gz"

OUTDIR=$1

emmc=$2


if [ "$emmc" = "" ]
then
    if grep /dev/mmcblk0 /proc/mounts | grep flash ; then
	emmc="/dev/mmcblk1"
    else
	emmc="/dev/mmcblk0"
    fi
else
    if [ ! -e "$emmc" ] ; then
	echo "Not found EMMC !!!!"
	exit 1
	fi
fi

if [ ! -f "$OUTDIR/$image" ] ; then
    echo "Not found file backup $OUTDIR/$image"
    exit 1
fi

gunzip -c $OUTDIR/$image.gz | dd of=/dev/$emmc

echo "Done! restore backup completed."

exit 0
