@common_introduction.md@
## Supported BSPs
- NXP LX2160ARDB Board: LX2160ACE Rev2.0-RDB, Board version: B

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-nxp-lx2xxx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-lx2xxx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    NOTE: The following firmware_lx2160ardb_rev2_uboot_sdboot.img is from NXP, it
    isn't integrated into WRLinux because of the license issue. You can
    get it from www.nxp.com, such as:
         wget https://www.nxp.com/lgfiles/sdk/lsdk2012/firmware_lx2160ardb_rev2_uboot_sdboot.img

    BUT YOU MUST CHECK WITH NXP ON WHETHER YOU CAN USE IT OR NOT.
    sudo dd if=firmware_lx2160ardb_rev2_uboot_sdboot.img of=/dev/sdX bs=512 seek=8 status=progress conv=fsync

### On Board
Specify boot medium, booting from SD card:
The following table shows the boot switch setup for SD boot

    Switch  D1      D2      D3      D4      D5      D6      D7      D8
    SW1     ON      OFF     OFF     OFF     ON      OFF     OFF     OFF

This should give you a bootable micro SD card device. Insert the SD card into
SD slot on the board, and then power on, then enter u-boot shell, the image
should boot, enter the following commands after image burned

    $ setenv boot_scripts boot.scr
    $ saveenv
    $ boot

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
