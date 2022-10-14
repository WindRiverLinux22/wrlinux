#!/bin/sh
#
# Copyright (c) 2022 Wind River Systems, Inc.
#
# SPDX-License-Identifier:  GPL-2.0
#
# Replace console=ttySX,baudrate with console=ttySY,baudrate in grub.cfg, the
# baudrate is optional. Root privilege is required
#
image=$1
new_console=$2

print_help() {
    echo Usage:
    echo "$0 <ustart.img.gz|wic> <console>"
    echo "For example:"
    echo "$0 ustart.img.gz console=ttyS6"
    echo "$0 file.wic console=ttyS1,115200"
    echo
    exit 1
}

if [ $# -ne 2 ]; then
    print_help
fi

# Root privilege is required
if [ $EUID -ne 0 ]; then
    echo "Root privilege is required." >&2
    exit 1
fi

if [ ! -e $image ]; then
    echo "$image doesn't exist." >&2
    exit 1
fi

# Unpack .gz if needed
decompressed=false
if [ "${image%.gz}" != "$image" ]; then
    echo "Decompressing $image..."
    gunzip $image
    image="${image%.gz}"
    decompressed=true
fi

# Check prefix "console="
if [ "${new_console#console=}" = "$new_console" ]; then
    new_console="console=$new_console"
fi

# Check baudrate
update_baud=false
if echo $new_console | grep -q ","; then
    update_baud=true
fi

losetup -f -P $image
image_dev=$(losetup -j $image | sed -e '1q' | sed -e 's/:.*//')
tmp_mnt=$(mktemp -d)
cmd="mount ${image_dev}p1 $tmp_mnt"
echo Running "$cmd"
$cmd

grub_cfg=$tmp_mnt/EFI/BOOT/grub.cfg

cleanup() {
    echo Cleaning up...
    umount $image_dev"p1"
    losetup -d $image_dev
    rm -fr $tmp_mnt
}

if [ ! -e $grub_cfg ]; then
    echo Cannot find $grub_cfg >&2
    cleanup
    exit 1
fi

if $update_baud; then
    old_console="$(sed -n 's/.*\(console=[^ ]*ttyS[^ ]*\).*/\1/p' $grub_cfg)"
else
    old_console="$(sed -n 's/.*\(console=[^ ]*ttyS[^,]*\).*/\1/p' $grub_cfg)"
fi

if [ "$old_console" = "$new_console" ]; then
    echo "Skipping updating since the consoles are the same: $old_console"
else
    echo "Updating serial console: \"$old_console\" -> \"$new_console\""
    sed -i "s/$old_console/$new_console/" $grub_cfg
fi

cleanup

if $decompressed; then
    echo Compressing $image
    gzip $image
fi
echo "Done"
