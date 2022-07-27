#!/bin/bash

set -e

[ -f **/$1.built ] && rm **/$1.built
[ -f **/$1.installed ] && rm **/$1.installed

jinx build-all
jinx sysroot

./build-support/gen_initramfs.sh sysroot
mv initrd.img sources/initrd.img
cp sources/initrd.img sources/ninex-workdir/initrd.img

