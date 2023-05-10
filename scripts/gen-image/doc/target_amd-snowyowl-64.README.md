@common_introduction.md@
## Supported BSPs
- AMD EPYC Embedded 3000 Series Snowy Owl platform

NOTE: The image's default serial console is ttyS4, you can use
update-grub-console.sh to set the correct serial console according to your
boards, run "update-grub-console.sh --help" to see more info.

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
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

@target_common_installer.md@
@common_package_manager.md@
