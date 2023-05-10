# Wind River Linux target images

The images are built from Wind River Linux, which support ostree, docker, kubernetes, xfce and other features in the packages feeds. The images can be highly customized, they can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Features
Arch: aarch64 (cortexa53)
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
- Xilinx ZYNQMP ZCU102 REV 1.0/1.1

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
    $ zcat wrlinux-image-full-xilinx-zynqmp.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-xilinx-zynqmp.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync

    NOTE: The following BOOT.BIN is from XILINX, it isn't integrated into
    WRLinux because of the license issue. It can be downloaded form the website:
    https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/183304302/2019.2+Release
    BUT YOU MUST CHECK WITH XILINX ON WHETHER YOU CAN USE IT OR NOT.

    $ mkdir tmp; sudo mount /dev/sdX1 ./tmp; sudo cp ./BOOT.BIN ./tmp
    $ sudo umount /dev/sdX*
    $ eject

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot on zcu102 board, and then power on, then enter
u-boot shell, the image should boot, enter the following commands if it
doesn't:

    $ setenv mmcdev 0
    $ setenv mmcpart 1
    $ setenv fdt_addr 0xE0000
    $ setenv scriptaddr 0x20000000
    $ setenv boot_script "/boot.scr"
    $ setenv boot_a_script "fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} zynqmp-zcu102-rev1.0.dtb;load mmc ${mmcdev}:${mmcpart} ${scriptaddr} ${boot_script}; source ${scriptaddr}"
    $ setenv mmc_boot "run boot_a_script"
    $ setenv bootcmd "run mmc_boot"
    $ saveenv

    # Boot the board
    $ run bootcmd


This should result in a system booted to the u-boot menu.

This BSP is only validated in following environment. If you use this BSP
in a different environment it may possibly have some issues.

        Processor:              ZYMQMP (410fd034 revision 4, Chip ID: xczu9eg)
        Board Revision:         Rev 1.0/1.1
        BootLoader:             U-Boot
        BootLoader Version:     U-Boot 2019.02


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
