EXTRA_KERNEL_FILES ?= ""
EXTRA_KERNEL_SRC_URI ?= ""

EXTRA_KERNEL_FILES:prepend = "${THISDIR}/linux-yocto:"

EXTRA_KERNEL_SRC_URI:append = " \
    file://0001-Revert-x86-ftrace-Use-alternative-RET-encoding.patch \
    file://0002-x86-ibt-ftrace-Make-function-graph-play-nice.patch \
    file://0003-x86-ftrace-Use-alternative-RET-encoding.patch \
"

EXTRA_KERNEL_FILES:prepend:bcm-2xxx-rpi4 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:bcm-2xxx-rpi4 = " \
    file://0001-Revert-Revert-mmc-sdhci-Mask-spurious-interrupts.patch \
"

FILESEXTRAPATHS:prepend:osv-wrlinux := "${EXTRA_KERNEL_FILES}:"
SRC_URI:append:osv-wrlinux = " ${EXTRA_KERNEL_SRC_URI}"
