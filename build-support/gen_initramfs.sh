#!/bin/bash

set -e

if test -z "$1"
then
	echo "USAGE: $0 <jinx sysroot>"
	exit 1
fi

# Copy over kernel modules
mkdir -p fake_sysroot/lib/
cp -r $1/lib/extensions fake_sysroot/lib/extensions

# Copy over mlibc libraries
cp $1/usr/lib/* fake_sysroot/lib/

# Finally, copy over a few binaries, for inspecting the system
cp -r $1/usr/bin fake_sysroot/bin

# Create the tarball, in ustar format (which the kernel uses)
tar --format=ustar -C fake_sysroot -cf initramfs.tar .

# Finally, compress and rename to initrd.img
gzip initramfs.tar
mv initramfs.tar.gz initrd.img
rm -rf fake_sysroot
