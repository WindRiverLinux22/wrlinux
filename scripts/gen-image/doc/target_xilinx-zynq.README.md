@common_introduction.md@
## Supported BSPs
- XILINX ZYNQ ZC706 Board  : XC7Z045 processor, Rev 2.0 board.
- XILINX ZYNQ ZC702 Board  : XC7Z020 processor, Rev 1.1 board.

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-xilinx-zynq.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-xilinx-zynq.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync

    NOTE: The following BOOT.BIN is from XILINX, it isn't integrated into
    WRLinux because of the license issue. It can be downloaded form the website:
    https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/183304302/2019.2+Release
    BUT YOU MUST CHECK WITH XILINX ON WHETHER YOU CAN USE IT OR NOT.

    $ mkdir tmp; sudo mount /dev/sdX1 ./tmp; sudo cp ./BOOT.BIN ./tmp
    $ sudo umount /dev/sdX*
    $ eject

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

@target_common_installer.md@
@common_package_manager.md@
