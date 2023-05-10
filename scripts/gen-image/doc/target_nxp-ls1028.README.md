@common_introduction.md@
## Supported BSPs
- NXP LS1028A-RDB: CortexA72, SCH RevA1

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
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

@target_common_installer.md@
@common_package_manager.md@
