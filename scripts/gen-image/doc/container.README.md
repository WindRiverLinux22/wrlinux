# Wind River Linux container images

The images are built from Wind River Linux, which support docker, kubernetes, xfce and other features in the packages feeds. The images can be highly customized, which can be customized by package manager dnf, or use the script gen-image to rebuild them from source.

## Supported BSPs
### x86-64
    intel-x86-64
    qemux86-64

### rpi4
    bcm-2xxx-rpi4
    qemuarm64

## Features
### x86-64
    Arch: x86_64 (corei7_64)
    Package Manager: dnf
    Features: docker kubernetes xfce

### rpi4
    Arch: aarch64 (cortexa72)
    Package Manager: dnf
    Features: docker kubernetes xfce

## Image types
### wrlinux-image-minimal
A busybox based minimal image that boots to a console, can be expanded to a
large image via package manager dnf.

### wrlinux-image-full
A full functional image that boots to a console, no busybox installed but other
common tools such as coreutils, and is installed by default.

## Install a package
    $ dnf install <package>

## Remove a package
    $ dnf remove <package>

## Dockerfile
### wrlinux-image-minimal
    FROM scratch
    ADD wrlinux-image-minimal-<machine>.tar.bz2 /
    CMD ["/bin/sh"]

### wrlinux-image-full
    FROM scratch
    ADD wrlinux-image-full-<machine>.tar.bz2 /
    CMD ["/bin/sh"]

The machine is  intel-x86-64 or bcm-2xxx-rpi4 according to the archs.

## Known issues
- ecryptfs-utils
ecryptfs-utils includes a systemd service ecryptfs.service and a kernel module
ecryptfs.ko. To make ecryptfs.service in container start successfully,
ecryptfs.ko must be inserted in the host system first either by ecryptfs.service
or manually. And then ecryptfs.service in the host system must be stopped,
otherwise it would hold /dev/ecryptfs and prevents ecryptfs.service in container
from accessing /dev/ecryptfs.
In general, a container may depend on some features or devices in the host
system. How to formally handle such dependencies is to be discussed.

