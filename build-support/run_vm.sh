#!/bin/bash

# Another script, this time for running CrecentOS in QEMU (bochs in future)

usage() {
	echo -e "usage: $0 [-i input] [-f disk format] [-k] [-w] [-d]\n"

	echo -e "Supported arguments:"
	echo -e "\t -i input                 specifies path to input image"
	echo -e "\t -f disk format           supported image formats: hd, cdrom"
	echo -e "\t -k                       use kvm for hardware acceleration"
	echo -e "\t -w                       enables VNC (for WSL2)"
	echo -e "\t -d                       enable GDB stub (for debugging)"
	echo -e "\t -h                       shows this help message\n"
}

if [ $# -eq 0 ]; then
	usage
	exit 0
fi

# Setup our default flags/variables...
QEMU_FLAGS="-m 1G -M q35 -debugcon stdio -smp `nproc` "
USING_CDROM=false

# Then parse the command line, and add flags as needed
image=
image_type=
use_kvm=0
wsl_mitigations=0
debugging=0

while getopts i:f:kwdh arg
do
	case $arg in
		i) image="$OPTARG";;
		f) image_type="$OPTARG"
			case "$image_type" in
				hd|cdrom);;
				*) echo "$0: Image type $parttype is not supported"; exit 1;;
			esac
			;;
		k) use_kvm=1;;
		w) wsl_mitigations=1;;
		d) debugging=1;;
		h) usage; exit 0;;
		?) echo "See -h for help."; exit 1;;
	esac
done

if [ -z "$image" ]; then
	echo "$0: Image file is required but wasn't specified."
	echo "See -h for help."
	exit 1;
fi
if [ -z "$image_type" ]; then
	echo "$0: Image type is required but wasn't specified."
	echo "See -h for help."
	exit 1;
fi

# Next, build up the command line
case "$image_type" in
	hd)
		QEMU_FLAGS+="-drive file=$image,if=virtio ";;
	cdrom)
		QEMU_FLAGS+="-cdrom $image ";;
esac

if [ "$use_kvm" = "1" ]; then
	QEMU_FLAGS+="--enable-kvm -cpu host,+invtsc "
else
	QEMU_FLAGS+="-accel tcg -cpu max,-la57 "
fi

if [ "$debugging" = "1" ]; then
	QEMU_FLAGS+="-s -monitor telnet::4321,server,nowait -no-reboot -no-shutdown "
fi

if [ "$wsl_mitigations" = "1" ]; then
	QEMU_FLAGS+="-vnc :0 "
fi

qemu-system-x86_64 $QEMU_FLAGS

