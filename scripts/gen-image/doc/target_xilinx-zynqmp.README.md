@common_introduction.md@
## Supported BSPs
- Xilinx ZYNQMP ZCU102 REV 1.0/1.1

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-xilinx-zynqmp.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-xilinx-zynqmp.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

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
Insert the SD card into SD slot on zcu102 board, and then power on, then enter
u-boot shell, the image should boot, enter the following commands if it
doesn't:

    $ setenv mmcdev 0
    $ setenv mmcpart 1
    $ setenv fdt_addr 0xE0000
    $ setenv scriptaddr 0x20000000
    $ setenv boot_script "/boot.scr"
    $ setenv boot_a_script "fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} zynqmp-zcu102-rev1.0.dtb;load mmc ${mmcdev}:${mmcpart} ${scriptaddr} ${boot_script}; source ${scriptaddr}"
    $ setenv mmc_boot "run boot_a_script"
    $ setenv bootcmd "run mmc_boot"
    $ saveenv

    # Boot the board
    $ run bootcmd


This should result in a system booted to the u-boot menu.

This BSP is only validated in following environment. If you use this BSP
in a different environment it may possibly have some issues.

        Processor:              ZYMQMP (410fd034 revision 4, Chip ID: xczu9eg)
        Board Revision:         Rev 1.0/1.1
        BootLoader:             U-Boot
        BootLoader Version:     U-Boot 2019.02

@target_common_installer.md@
@common_package_manager.md@
