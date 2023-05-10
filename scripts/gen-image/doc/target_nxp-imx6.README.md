@common_introduction.md@
## Supported BSPs
- MX6 UltraLite   : Board: Freescale UltraLite EVK REV C2 SCH-28616 700-28616 REV C. CPU: PCIMX6G2CVM05AA CTAE1545

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-nxp-imx6.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-imx6.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    NOTE: The following u-boot-imx6ul14x14evk_sd.imx is from NXP, it
    isn't integrated into WRLinux because of the license issue. You can
    get it from www.nxp.com, such as:
        1) Download LF_v5.10_1.0.0_images_IMX6UL7D.zip from the follow link:
           https://www.nxp.com/webapp/Download?colCode=L5.10.9_1.0.0_MX6UL7D&appType=license
        2) upzip the file to get the u-boot-imx6ul14x14evk_sd.imx

    BUT YOU MUST CHECK WITH NXP ON WHETHER YOU CAN USE IT OR NOT.

    $ sudo umount /dev/sdX*
    $ sudo dd if=u-boot-imx6ul14x14evk_sd.imx of=/dev/sdX bs=1k seek=1 conv=fsync
    $ sudo eject /dev/sdX

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

@target_common_installer.md@
@common_package_manager.md@
