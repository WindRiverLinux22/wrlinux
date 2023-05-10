@common_introduction.md@
## Supported BSPs
- AMD EPYC Embedded 3000 Series Snowy Owl platform

NOTE: The image's default serial console is ttyS4, you can use
update-grub-console.sh to set the correct serial console according to your
boards, run "update-grub-console.sh --help" to see more info.

## How to install/boot binary image

### On Host PC
Under Linux, insert a USB flash drive.  Assuming the USB flash drive
takes device /dev/sdX, use dd to copy the image to it.  Before the image
can be burned onto a USB drive, it should be un-mounted. Some Linux distros
may automatically mount a USB drive when it is plugged in. Using USB device
/dev/sdX as an example, find all mounted partitions:

    $ mount | grep sdX

and un-mount those that are mounted, for example:

    $ sudo umount /dev/sdX*

Now burn the image onto the USB drive:
    For full image
    $ zcat wrlinux-image-full-amd-snowyowl-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-amd-snowyowl-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync
    $ eject /dev/sdX

This should give you a bootable USB flash device.

### On Board
Insert the device into a bootable USB socket on the target, and power on.

The image will be installed on the boot disk (USB) by default, you can press
any key except 'y' to stop the installation and select other disks to install:

## Erasing /dev/sda in 60 sec ## 'y' = start ## Any key to abort ##
## Erasing /dev/sda in 59 sec ## 'y' = start ## Any key to abort ##
    NAME   VENDOR    SIZE MODEL            TYPE LABEL
0 - sda    QEMU        8G QEMU HARDDISK    disk
B - Reboot
Select disk to format and install:

You will see the login console after the installation is done and rebooted,
login with root and change password for the first login.

@common_package_manager.md@
