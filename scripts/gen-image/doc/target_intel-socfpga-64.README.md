@common_introduction.md@
## Supported BSPs
- Intel Stratix 10 SOCFPGA board: CortexA53 processor, Rev B0 Board.

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-intel-socfpga-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-intel-socfpga-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync

    $ eject /dev/sdX

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

@target_common_installer.md@
@common_package_manager.md@
