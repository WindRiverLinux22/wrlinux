@common_introduction.md@
## Supported BSPs
- NXP LS1028A-RDB: CortexA72, SCH RevA1

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
    $ zcat wrlinux-image-full-nxp-ls1028.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-ls1028.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    NOTE: The following firmware_ls1028ardb_uboot_xspiboot.img is from NXP, it
    isn't integrated into WRLinux because of the license issue. You can
    get it from www.nxp.com, such as:
         wget https://www.nxp.com/lgfiles/sdk/lsdk2012/firmware_ls1028ardb_uboot_xspiboot.img

    BUT YOU MUST CHECK WITH NXP ON WHETHER YOU CAN USE IT OR NOT.

    $ sudo partprobe /dev/sdX
    $ mkdir -p ./tmp && sudo mount /dev/sdX1 ./tmp
    $ cp ./firmware_ls1028ardb_uboot_xspiboot.img ./tmp
    $ sudo umount /dev/sdX*
    $ sudo eject /dev/sdX

### On Board
Currently, it only supports SPI nor flash as the board bootloader.
And please set the on-board switch options as following to enable
boot from SPI nor flash:

    Boot source  SW2[1:8]        SW3[1:8]        SW5[1:8]
    FSPI NOR     1111_1000       1111_0000       0011_1001

This should give you a bootable micro SD card device. Insert the SD card into
SD slot on the board, and then power on, then enter u-boot shell, the image
should boot, enter the following commands if it doesn't:

First, following uboot env may have wrong value, please set it as following:

    $ setenv kernel_addr_r 0x80080000
    $ setenv ramdisk_addr_r 0x90080000
    $ setenv fdt_addr 0xa0000000
    $ saveenv
    $ run bootcmd

If it still not boot up, try:

    $ fatsize mmc 0:1 firmware_ls1028ardb_uboot_xspiboot.img
    $ fatload mmc 0:1 0xa0000000 firmware_ls1028ardb_uboot_xspiboot.img $filesize
    $ sf probe 0:0
    $ sf erase 0 +$filesize
    $ sf write 0xa0000000 0 $filesize
    $ qixis_reset

Enter u-boot shell again:
    $ setenv boot_scripts boot.scr
    $ saveenv

    # Boot the board
    $ run bootcmd

The image will be installed on the boot disk (SD card) by default, you can
press any key except 'y' to stop the installation and select other disks to
install:
```
## Erasing /dev/sda in 60 sec ## 'y' = start ## Any key to abort ##
## Erasing /dev/sda in 59 sec ## 'y' = start ## Any key to abort ##
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda    QEMU        8G QEMU HARDDISK    disk
B - Reboot
Select disk to format and install:
```
You will see the login console after the installation is done and rebooted,
login with root and change password for the first login.

@common_package_manager.md@
