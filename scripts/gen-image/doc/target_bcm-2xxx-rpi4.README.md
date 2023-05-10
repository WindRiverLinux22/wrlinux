# Wind River Linux target images

The images are built from Wind River Linux, which support ostree, docker, kubernetes, xfce and other features in the packages feeds. The images can be highly customized, they can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Features
Arch: aarch64 (cortexa72)
Package Manager: dnf
Features: ostree docker kubernetes xfce

### ostree
OSTree is a system for versioning updates of Linux-based operating
systems. It can be considered as "Git for operating system binaries".
It operates in userspace, and will work on top of any Linux file system.
At its core is a Git-like content-addressed object store with branches
(or "refs") to track meaningful file system trees within the store.
Similarly, one can check out or commit to these branches.

#### Ostree Upgrade

  $ ostree_upgrade.sh

This command wraps the ostree admin commands and handles the upgrade
using a single or multi-partition device in order to obtain the
specified branch configured in /sysroot/ostree/repo/config.

  Optional commands:

  -b   reboot after completion
  -e   Erase the /var volume on the next reboot
  -E   FORMAT the /var volume when on a separate partition on the next reboot
  -f   Force /etc to be entirely reset to the initial deploy state
  -r   Redeploy the current branch without doing a network pull
  -s   Skip the fsck integrity checks

  -F   Local Factory reset, uses -b -e -f -r -s
  -U   Factory upgrade reset, uses -b -e -f -s

NOTE: On target, run ostree_upgrade.sh to update the image rather than
'ostree pull'. Use "ostree remote add wrlinux xxx" to add remote repo
if not present.

## Supported BSPs
- Raspberry Pi 4 Model B: BCM2711 rev1.1, with 4G DDR memory
- Raspberry Pi 4 Model B: BCM2711 rev1.2, with 4G DDR memory
- Raspberry Pi 4 Model B: BCM2711 rev1.4, with 8G DDR memory
- qemuarm64

## How to install/boot binary image

### On Host PC
Under Linux, insert a micro SD card to a USB SD Card Reader.
Assuming the USB SD Card Reader takes device /dev/sdX, use dd
to copy the image to it. Before the image can be burned onto
a micro SD card, it should be un-mounted. Some Linux distros
may automatically mount when it is plugged in. Using device
/dev/sdX as an example, find all mounted partitions:

    $ mount | grep sdX

and un-mount those that are mounted, for example:

    $ sudo umount /dev/sdX*

Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-bcm-2xxx-rpi4.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-bcm-2xxx-rpi4.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync
    $ eject /dev/sdX

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

The image will be installed on the boot disk (SD card) by default, you can
press any key except 'y' to stop the installation and select other disks to
install:

## Erasing /dev/sda in 60 sec ## 'y' = start ## Any key to abort ##
## Erasing /dev/sda in 59 sec ## 'y' = start ## Any key to abort ##
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda    QEMU        8G QEMU HARDDISK    disk
B - Reboot
Select disk to format and install:

You will see the login console after the installation is done and rebooted,
login with root and change password for the first login.

### On Qemu
Create a 8G disk image
    $ qemu-img create -f raw boot-image-qemu.hddimg 8G

Burn the image onto 8G disk image:
    For full image
    $ zcat wrlinux-image-full-bcm-2xxx-rpi4.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

    For minimal image
    $ zcat wrlinux-image-minimal-bcm-2xxx-rpi4.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

For Qemu No Graphic:

    $ qemu-system-aarch64 -machine virt -cpu cortex-a57 \
        -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
        -m 512 \
        -bios qemu-u-boot-bcm-2xxx-rpi4.bin \
        -nographic \
        -drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0

Or Qemu Graphic (XFCE desktop):

    $ qemu-system-aarch64 -machine virt -cpu cortex-a57 \
        -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
        -m 512 \
        -bios qemu-u-boot-bcm-2xxx-rpi4.bin \
        -device virtio-gpu-pci -serial stdio \
        -device qemu-xhci -device usb-tablet -device usb-kbd \
        -drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0

#### Qemu Simulator (require 2.11 or higher)
qemu-system-aarch64

#### Qemu Networking
Create a SLiRP user network
`-device virtio-net-device,netdev=net0 -netdev user,id=net0`

#### Qemu Memory
Set guest startup RAM size, 512MB
`-m 512`

#### Qemu Image
Use virtio-blk-device to load image
`-drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0`

#### Qemu CPU
Use QEMU 2.11 ARM Virtual Machine with CPU cortex-a57
`-machine virt -cpu cortex-a57`

#### Qemu Bootloader
Add pre-built qemu bootloader qemu-u-boot-bcm-2xxx-rpi4.bin
`-bios qemu-u-boot-bcm-2xxx-rpi4.bin`

#### Qemu Graphic (XFCE desktop)
Enable graphical and redirect serial I/Os to console
`-device virtio-gpu-pci -serial stdio`

Add Mouse and Keyboard
`-device qemu-xhci -device usb-tablet -device usb-kbd`

@common_package_manager.md@
