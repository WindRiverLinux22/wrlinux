@common_introduction.md@
## Supported BSPs
- TI J721E(DRA829/TDA4xM) EVM: Board: J7X-BASE-CPB rev E3, J721EX-PM2-SOM rev E7

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-ti-j72xx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-ti-j72xx.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync

    NOTE:
    1. The following boot files are from TI, they are not integrated into
    WRLinux because of the license issue. Follow webset:
        http://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/latest/index_FDS.html
    click the boot-j7-evm.tar.gz link to download it, BUT YOU MUST CHECK WITH
    TI ON WHETHER YOU CAN USE IT OR NOT. Here is an example to download
    boot-j7-evm.tar.gz with version 08.00.00.08
    2. The TI's bootloader file u-boot.img/tispl.bin has been compiled and integrated into
    WRLinux WIC, it does not need to copy from TI SDK.
    $ wget https://software-dl.ti.com/jacinto7/esd/processor-sdk-linux-jacinto7/08_00_00_08/exports/boot-j7-evm.tar.gz
    $ mkdir boot-j7-evm && tar xzvf boot-j7-evm.tar.gz -C boot-j7-evm
    $ mkdir -p ./tmp && sudo mount /dev/sdX1 ./tmp
    $ sudo cp boot-j7-evm/* ./tmp
    $ sudo umount ./tmp
    $ eject /dev/sdX

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

@target_common_installer.md@
@common_package_manager.md@
