#!/bin/bash

# Creates a image and installs the CrecentOS userspace onto it...
set -ex

# First, make sure we're running in the right directory, and a sysroot exists!
if [ ! "$(basename $(pwd))" = "CrecentOS" ]
then
	printf "create_image.sh: directory %s is not the source root!" "$(basename $(pwd))"
fi
[ ! -d "sysroot" ] && jinx sysroot

# Next, create the hard disk (if not already present)
if [ ! -f "crcnt.hdd" ] 
then
	# Create the image file
	dd if=/dev/zero of=crcnt.hdd bs=1M count=130
	parted -s crcnt.hdd mklabel gpt
	parted -s crcnt.hdd mkpart primary fat32 1M  64M
	parted -s crcnt.hdd mkpart primary ext2  65M 129M

	# Create initial partitions
	LOOP_ROOT=`sudo losetup -Pf --show crcnt.hdd`
	sudo mkfs.fat -F 32 "${LOOP_ROOT}p1"
	sudo mkfs.ext2 "${LOOP_ROOT}p2"
	sudo losetup -d "${LOOP_ROOT}"

	# Install limine
	[ ! -d "host-pkgs/limine" ] && jinx host-build limine
	./host-pkgs/limine/usr/local/bin/limine-deploy crcnt.hdd
	cp host-pkgs/limine/usr/local/share/limine/limine.sys sysroot/boot/limine.sys
fi

# Copy the initrd.img into the sysroot, if its not there
if [ ! -f "sysroot/boot/initrd.img" ]
then
	# If the initrd is missing, then other things are missing too, so copy them...
	./build-support/gen_initramfs.sh sysroot
	mv initrd.img sysroot/boot/initrd.img
	cp build-support/{limine.cfg,splash.bmp} sysroot/boot/
fi

# Finally, sync the sysroot to disk
./build-support/update_image.sh sysroot crcnt.hdd

