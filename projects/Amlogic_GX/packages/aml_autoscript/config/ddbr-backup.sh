#!/bin/sh

BACKUP_DATE=$(date +%Y%m%d%H%M%S)
image="EMMC-backup-$(date +%Y%m%d%H%M%S).img"


OUTDIR=$1

emmc=$2

echo "Start FULL backup eMMC to /storage/backup"

if [ "$emmc" = "" ]
then
    emmc="/dev/mmcblk1"
else
    if [ ! -e "$OUTDIR" ] ; then
	echo "Not found EMMC !!!!"
	    exit 1
	fi
fi

if [ "$OUTDIR" = "" ]
then
    OUTDIR="/storage/backup/ddbr"
    [ ! -d $OUTDIR ] && mkdir -p $OUTDIR
else
    OUTDIR=$(echo "$OUTDIR" | sed "s,/\+$,,")
    echo "$_b ARGUMENT MODE DETECTED. YOU HAVE BEEN WARNED!!!       $_x"
    echo "$_b NO IN/OUT SIZE CHECKS WILL BE PERFORMED IN THIS MODE. $_x"
    echo "$_b YOU ARE USING THIS MODE AT YOUR OWN RISK!!! $_x"
	if [ ! -d "$OUTDIR" ]
	then
	    echo "$_r IN ARGUMENT MODE THE OUT/IN DIRECTORY MUST PRE-EXIST $_x"
	    echo "$_r AND IT IS BETTER TO BE ON AN MOUNTED EXTERNAL DRIVE. $_x"
	    echo "$_r PROGRAM EXITED DUE TO ERROR: NO DIR $OUTDIR          $_x"
	    exit 1
	fi
fi

dd if=$emmc | gzip > $OUTDIR/$image.gz

echo "Done"

exit 0
