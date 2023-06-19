@common_introduction.md@
## Supported BSPs
- MCIMX8QM-MEK: Board: MCIMX8QM-MEK SCH-29420 REV C2, 700-29420 REV C2.
			    CPU: NXP i.MX8QM RevB A53 at 1200 MHz at 27C

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
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

@target_common_installer.md@
@common_package_manager.md@
