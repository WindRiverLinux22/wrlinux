#
# Copyright (C) 2012-2016 Wind River Systems Inc.
#

DESCRIPTION = "Core packages for Linux/GNU (non-busybox) runtime images"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

ALLOW_EMPTY:${PN} = "1"
ALLOW_EMPTY:${PN}-net = "1"
ALLOW_EMPTY:${PN}-discrete-tools = "1"

PACKAGES += "${PN}-net ${PN}-net-dbg ${PN}-net-dev"
PACKAGES += "${PN}-discrete-tools ${PN}-discrete-tools-dbg ${PN}-discrete-tools-dev"

# Core userspace package list based roughly on oe-core's
# packagegroup-core-initscripts and packagegroup-core-basic-utils:
VIRTUAL-RUNTIME_syslog ?= "sysklogd"
RDEPENDS:${PN} = "\
    acl \
    attr \
    bash \
    bc \
    coreutils \
    cpio \
    e2fsprogs \
    ed \
    findutils \
    gawk \
    grep \
    iproute2 \
    kmod \
    logrotate \
    mingetty \
    ncurses \
    procps \
    psmisc \
    sed \
    sudo \
    ${VIRTUAL-RUNTIME_syslog} \
    tar \
    time \
    udev \
    util-linux \
    util-linux-mount \
    util-linux-umount \
    util-linux-fstrim \
    util-linux-hwclock \
    util-linux-logger \
    vim \
    which \
    "

# Minimal network environment
RDEPENDS:${PN}-net = "\
    dhcpcd \
    ethtool \
    net-tools \
    rfkill \
    "

# Some subsitutes for busybox functions
RDEPENDS:${PN}-discrete-tools = "\
    adduser \
    debianutils-run-parts \
    ifupdown \
    "
