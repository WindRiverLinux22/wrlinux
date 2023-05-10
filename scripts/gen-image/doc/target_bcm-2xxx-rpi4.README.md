@common_introduction.md@
## Supported BSPs
- Raspberry Pi 4 Model B: BCM2711 rev1.1, with 4G DDR memory
- Raspberry Pi 4 Model B: BCM2711 rev1.2, with 4G DDR memory
- Raspberry Pi 4 Model B: BCM2711 rev1.4, with 8G DDR memory
- qemuarm64

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the micro SD card:
    For full image
    $ zcat wrlinux-image-full-bcm-2xxx-rpi4.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-bcm-2xxx-rpi4.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync
    $ eject /dev/sdX

This should give you a bootable micro SD card device.

### On Board
Insert the SD card into SD slot, and then power on.

@target_common_installer.md@
### On Qemu
Create a 8G disk image
    $ qemu-img create -f raw boot-image-qemu.hddimg 8G

Burn the image onto 8G disk image:
    For full image
    $ zcat wrlinux-image-full-bcm-2xxx-rpi4.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

    For minimal image
    $ zcat wrlinux-image-minimal-bcm-2xxx-rpi4.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

For Qemu No Graphic:

    $ qemu-system-aarch64 -machine virt -cpu cortex-a57 \
        -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
        -m 512 \
        -bios qemu-u-boot-bcm-2xxx-rpi4.bin \
        -nographic \
        -drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0

Or Qemu Graphic (XFCE desktop):

    $ qemu-system-aarch64 -machine virt -cpu cortex-a57 \
        -device virtio-net-device,netdev=net0 -netdev user,id=net0 \
        -m 512 \
        -bios qemu-u-boot-bcm-2xxx-rpi4.bin \
        -device virtio-gpu-pci -serial stdio \
        -device qemu-xhci -device usb-tablet -device usb-kbd \
        -drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0

#### Qemu Simulator (require 2.11 or higher)
qemu-system-aarch64

#### Qemu Networking
Create a SLiRP user network
`-device virtio-net-device,netdev=net0 -netdev user,id=net0`

#### Qemu Memory
Set guest startup RAM size, 512MB
`-m 512`

#### Qemu Image
Use virtio-blk-device to load image
`-drive id=disk0,file=boot-image-qemu.hddimg,if=none,format=raw -device virtio-blk-device,drive=disk0`

#### Qemu CPU
Use QEMU 2.11 ARM Virtual Machine with CPU cortex-a57
`-machine virt -cpu cortex-a57`

#### Qemu Bootloader
Add pre-built qemu bootloader qemu-u-boot-bcm-2xxx-rpi4.bin
`-bios qemu-u-boot-bcm-2xxx-rpi4.bin`

#### Qemu Graphic (XFCE desktop)
Enable graphical and redirect serial I/Os to console
`-device virtio-gpu-pci -serial stdio`

Add Mouse and Keyboard
`-device qemu-xhci -device usb-tablet -device usb-kbd`

@common_package_manager.md@
