# Wind River Linux target images

The images are built from Wind River Linux, which support ostree, docker, kubernetes, xfce and other features in the packages feeds. The images can be highly customized, they can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Features
Arch: aarch64 (cortexa72)
Package Manager: dnf
Features: ostree docker kubernetes

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
- TI J721E(DRA829/TDA4xM) EVM: Board: J7X-BASE-CPB rev E3, J721EX-PM2-SOM rev E7

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
    $ zcat wrlinux-image-full-ti-j72xx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-ti-j72xx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync

    NOTE:
    1. The following boot files are from TI, they are not integrated into
    WRLinux because of the license issue. Follow webset:
        http://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/latest/index_FDS.html
    click the boot-j7-evm.tar.gz link to download it, BUT YOU MUST CHECK WITH
    TI ON WHETHER YOU CAN USE IT OR NOT. Here is an example to download
    boot-j7-evm.tar.gz with version 08.00.00.08
    2. The TI's bootloader file u-boot.img/tispl.bin has been compiled and integrated into
    WRLinux WIC, it does not need to copy from TI SDK.
    $ wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/08_00_00_08/exports/boot-j7-evm.tar.gz
    $ mkdir boot-j7-evm && tar xzvf boot-j7-evm.tar.gz -C boot-j7-evm
    $ mkdir -p ./tmp && sudo mount /dev/sdX1 ./tmp
    $ sudo cp boot-j7-evm/* ./tmp
    $ sudo umount ./tmp
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

@common_package_manager.md@
