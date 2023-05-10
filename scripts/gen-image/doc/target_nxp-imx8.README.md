@common_introduction.md@
## Supported BSPs
- MCIMX8QM-MEK: Board: MCIMX8QM-MEK SCH-29420 REV C2, 700-29420 REV C2.
			    CPU: NXP i.MX8QM RevB A53 at 1200 MHz at 27C
- MCIMX8M-EVK: Board: MCIMX8M-EVK SCH-29615 REV B3, 700-29615 REV X6.
               CPU: Freescale i.MX8MQ rev2.0 1500 MHz

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
    $ zcat wrlinux-image-full-nxp-imx8.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    Or minimal image
    $ zcat wrlinux-image-minimal-nxp-imx8.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress conv=fsync

    NOTE: The following imx-boot-imx8qmmek-sd-5-4.bin-flash and
    5.10.72-2.2.0_imx-boot-imx8mqevk-sd.bin-flash_evk is from NXP, it isn't
    integrated into WRLinux because of the license issue. You can ask NXP for it.
    BUT YOU MUST CHECK WITH NXP ON WHETHER YOU CAN USE IT OR NOT.

    $ sudo umount /dev/sdX*

    - For MCIMX8QM-MEK board:
      $ sudo dd if=imx-boot-imx8qmmek-sd-5-4.bin-flash of=/dev/sdX bs=1k seek=32 conv=fsync

    - For MCIMX8M-EVK board:
      $ sudo dd if=5.10.72-2.2.0_imx-boot-imx8mqevk-sd.bin-flash_evk of=/dev/sdX bs=1k seek=33 conv=fsync

    $ sudo eject /dev/sdX

    Note, the seek number is different (32 and 33)

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
