# Wind River Linux target images

The images are built from Wind River Linux, which support ostree, docker, kubernetes and other features in the packages feeds. The images can be highly customized, they can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Features
Arch: aarch64 (octeontx2)
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
- Marvell CN96XX-CRB board, Board Revision: R1P1

## How to install/boot binary image

### On Host PC
Under Linux, insert a micro SD card to a USB SD Card Reader. Assuming the USB
SD Card Reader takes device /dev/sdX, use dd to burn the image to it. Before
the image can be burned onto a micro SD card, it should be un-mounted. Some
Linux distros may automatically mount when it is plugged in. Using device
/dev/sdX as an example, find all mounted partitions:

    $ sudo umount /dev/sdX*

Now burn the image onto the micro SD card:
    For full image
    $ ./marvell-cn96xx-sd.sh wrlinux-image-full-marvell-cn9xxx.ustart.img.gz octeontx-bootfs-uboot-t96.img /dev/sdX

    Or minimal image
    $ ./marvell-cn96xx-sd.sh wrlinux-image-minimal-marvell-cn9xxx.ustart.img.gz octeontx-bootfs-uboot-t96.img /dev/sdX

    NOTE: The octeontx-bootfs-uboot-t96.img is from MARVELL, it isn't
    integrated into WRLinux because of the license issue. You can ask MARVELL for it.
    BUT YOU MUST CHECK WITH MARVELL ON WHETHER YOU CAN USE IT OR NOT.

### On Board
Specify boot medium, set SW1 on the board to boot from SD0 card
  +-------+-------+-------+----------------------+
  | bit 1 | bit 2 | bit 3 |      boot device     |
  +-------+-------+-------+----------------------+
  |  on   |  on   |  on   |       SD0 card       |
  +-------+-------+-------+----------------------+

This should give you a bootable micro SD card device. Insert the SD card into
SD slot, and then power on, and input the following commands in the u-boot shell:

    $ setenv bootcmd "fatload mmc 0:1 $loadaddr boot.itb; source $loadaddr:script-1;"
    $ saveenv
    $ boot


You may see the following table before u-boot start:
    Boot Options
    =================================
    S) Enter Setup
    E) Enter Diagnostics, skipping Setup
    W) Burn boot flash using Xmodem
    U) Change baud rate and flow control
    R) Reboot

    You can setup the board as:
    S -> B: Enter cn96xx-crb
    N: Enter 9
    W: Save data
    Q: Return to main menu

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
