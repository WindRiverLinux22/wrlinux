# Wind River Linux target images

The images are built from Wind River Linux, which support ostree, docker, kubernetes, xfce and other features in the packages feeds. The images can be highly customized, they can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Features
Arch: x86_64 (corei7_64)
Package Manager: dnf
Features: ostree docker kubernetes xfce

### ostree
OSTree is a system for versioning updates of Linux-based operating
systems. It can be considered as "Git for operating system binaries".
It operates in userspace, and will work on top of any Linux file system.
At its core is a Git-like content-addressed object store with branches
(or "refs") to track meaningful file system trees within the store.
Similarly, one can check out or commit to these branches.

#### Ostree Upgrade

  $ ostree_upgrade.sh

This command wraps the ostree admin commands and handles the upgrade
using a single or multi-partition device in order to obtain the
specified branch configured in /sysroot/ostree/repo/config.

  Optional commands:

  -b   reboot after completion
  -e   Erase the /var volume on the next reboot
  -E   FORMAT the /var volume when on a separate partition on the next reboot
  -f   Force /etc to be entirely reset to the initial deploy state
  -r   Redeploy the current branch without doing a network pull
  -s   Skip the fsck integrity checks

  -F   Local Factory reset, uses -b -e -f -r -s
  -U   Factory upgrade reset, uses -b -e -f -s

NOTE: On target, run ostree_upgrade.sh to update the image rather than
'ostree pull'. Use "ostree remote add wrlinux xxx" to add remote repo
if not present.

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
    $ zcat image-full-intel-x86-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

    Or minimal image
    $ zcat wrlinux-image-minimal-intel-x86-64.ustart.img.gz | sudo dd of=/dev/sdX bs=1M status=progress

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
