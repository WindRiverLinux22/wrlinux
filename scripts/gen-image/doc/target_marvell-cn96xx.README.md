@common_introduction.md@
## Supported BSPs
- Marvell CN96XX-CRB board, Board Revision: R1P1

## How to install/boot binary image

### On Host PC
@target_common_usb.md@

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
