#!/bin/bash

# A somewhat complex script for syncing SYSTEM_ROOT with the physical image
# does other partition stuff too

set -e

if test -z "$1" || test -z "$2"
then
	echo "USAGE: update_image.sh <jinx sysroot> <image file>"
	exit 1
fi

SYSTEM_ROOT=$1
LOOP_ROOT=`sudo losetup -Pf --show $2`
P0MNT_DIR=/tmp/mount$(shuf -i 0-100000 -n1)
P1MNT_DIR=/tmp/mount$(shuf -i 0-100000 -n1)
P0MNT_ID="${LOOP_ROOT}p1"
P1MNT_ID="${LOOP_ROOT}p2"

# Mount the 2 partitions
mkdir $P0MNT_DIR $P1MNT_DIR
sudo mount -o rw $P0MNT_ID $P0MNT_DIR
sudo mount -o rw $P1MNT_ID $P1MNT_DIR

# Copy over the kernel and other files to the first partition
sudo rsync -rtDvz --delete $SYSTEM_ROOT/boot/ $P0MNT_DIR/boot/

# Then copy over the rest onto the second partition
sudo rsync -a --delete $SYSTEM_ROOT/boot/ $P1MNT_DIR/boot/
sudo rsync -a --delete $SYSTEM_ROOT/usr/ $P1MNT_DIR/usr/
sudo rsync -a --delete $SYSTEM_ROOT/bin/ $P1MNT_DIR/bin/
sudo rsync -a --delete $SYSTEM_ROOT/lib/ $P1MNT_DIR/lib/

# Cleanup our mess
sudo umount $P0MNT_DIR 
sudo umount $P1MNT_DIR
rm -rf $P0MNT_DIR $P1MNT_DIR
sudo losetup -d $LOOP_ROOT 

