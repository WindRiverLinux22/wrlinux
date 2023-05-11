@common_introduction.md@
## Supported BSPs
- Intel NUC Platform: KabyLake-U Processor, Sunrise Point-LP PCH, (NUC7i5DNK1E)
- Intel Tiger Lake UP3: 11th Gen Intel(R) Core(TM) processors
- Intel Ice Lake-SP: 3rd Gen Intel(R) Xeon(R) Scalable processor
- Intel Snow Ridge: Intel Atom(R) P5362 processor
- Intel Elkhart Lake: Intel Atom(R) x6425RE Processor
- qemux86-64

NOTE: The image's default serial console is ttyS0, you can use
update-grub-console.sh to set the correct serial console according to your
boards, run "update-grub-console.sh --help" to see more info.

## How to install/boot binary image

### On Host PC
@target_common_usb.md@
Now burn the image onto the USB drive:
    For full image
    $ zcat wrlinux-image-full-intel-x86-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-intel-x86-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    $ sync
    $ eject /dev/sdX

This should give you a bootable USB flash device.

### On Board
Insert the device into a bootable USB socket on the target, and power on.

@target_common_installer.md@

### On Qemu
Create a 8G disk image
    $ qemu-img create -f raw boot-image-qemu.hddimg 8G

Burn the image onto 8G disk image:
    For full image
    $ zcat wrlinux-image-full-intel-x86-64.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

    For minimal image
    $ zcat wrlinux-image-minimal-intel-x86-64.ustart.img.gz | dd of=boot-image-qemu.hddimg conv=notrunc

For qemu x86_64 with KVM:

    $ qemu-system-x86_64 -net nic -net user -m 512 \
        -drive if=none,id=hd,file=boot-image-qemu.hddimg,format=raw \
        -device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd \
        -cpu kvm64 -enable-kvm \
        -drive if=pflash,format=qcow2,file=ovmf.qcow2 -nographic

For qemu x86_64 without KVM:

    $ qemu-system-x86_64 -net nic -net user -m 512 \
        -drive if=none,id=hd,file=boot-image-qemu.hddimg,format=raw \
        -device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd \
        -cpu Nehalem \
        -drive if=pflash,format=qcow2,file=ovmf.qcow2 -nographic

Note, remove '-nographic' to enable graphical output

#### Qemu Simulator (require 2.11 or higher)
qemu-system-x86_64

#### Qemu Networking
Create a SLiRP user network
`-net nic -net user`

#### Qemu Memory
Set guest startup RAM size, 512MB
`-m 512`

#### Qemu Image
Use virtio-scsi-pci to load image
`-drive if=none,id=hd,file=boot-image-qemu.hddimg,format=raw -device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd`

#### Qemu CPU
- KVM
KVM has better performance based on virtualization as most of guest
instruction can be executed directly on the host processor.
`-cpu kvm64 -enable-kvm`
If kvm failed, please refer:
https://wiki.yoctoproject.org/wiki/How_to_enable_KVM_for_Poky_qemu

If above refer does not work (such as you do not have root right to enable kvm)

- For qemu x86_64, please simulate Intel Core i7 9xx (Nehalem Class Core i7)
`-cpu Nehalem`

#### Qemu Bootloader
Enable UEFI support for Virtual Machines
`-drive if=pflash,format=qcow2,file=ovmf.qcow2`

@common_package_manager.md@
