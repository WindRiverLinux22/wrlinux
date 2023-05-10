@common_introduction.md@
## Supported BSPs
- NXP LS1043A-RDB: SCH-28529 REV B1 (LS1043A Rev1.0)

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-nxp-ls1043.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-ls1043.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    NOTE: The following firmware_ls1043ardb_sdboot.img is from NXP, it
    isn't integrated into WRLinux because of the license issue. You can
    get it from www.nxp.com, such as:
         wget https://www.nxp.com/lgfiles/sdk/lsdk2108/firmware_ls1043ardb_sdboot.img

    BUT YOU MUST CHECK WITH NXP ON WHETHER YOU CAN USE IT OR NOT.
    sudo dd if=./firmware_ls1043ardb_sdboot.img of=/dev/sdX bs=512 seek=8 status=progress conv=fsync

### On Board
Board can boot from SD card by setting sw4[1:8] as '00100000' and sw5[1:8] as '00100010'.
After power up, if a bootable SD card inserted, then system will boot from SD
card.

This should give you a bootable micro SD card device. Insert the SD card into
SD slot on the board, and then power on, then enter u-boot shell, the image
should boot, enter the following commands after image burned

    $ setenv boot_scripts boot.scr
    $ saveenv
    $ boot

@target_common_installer.md@
@common_package_manager.md@
