@common_introduction.md@
## Supported BSPs
- NXP S32G399A-EVB: Board: S32GRV-PLATEVB (SCH-30081 REV B, 700-30081 REV B)
                    S32G-PROCEVB-S
                    CPU: NXP S32G399A rev. 1.0
- NXP S32G399A-RDB3: Board: S32G399A-VNP-RDB3 (SCH-53060 REV E1, 700-53060 REV X2)
                     CPU: NXP S32G399A rev. 1.0

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:

The <boardtype> is rdb3 or evb3 which depends on your hardware.

    For full image
    $ zcat wrlinux-image-full-nxp-s32g.ustart-<boardtype>.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-s32g.ustart-<boardtype>.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync
    $ eject /dev/sdX

This should give you a bootable micro SD card device.


### On Board
Note for EVB3, the board must enable MMC and disable eMMC, otherwise, it may
fail to boot, the Jumper J50 should have the following values:

+-------+-------+-------+
| pin 1 | pin 2 | pin 3 |
+-------+-------+-------+
|  on   |  on   |  off  |
+-------+-------+-------+


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
