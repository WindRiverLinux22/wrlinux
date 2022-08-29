EXTRA_KERNEL_FILES ?= ""
EXTRA_KERNEL_SRC_URI ?= ""
EXTRA_KERNEL_FILES:prepend:bcm-2xxx-rpi4 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:bcm-2xxx-rpi4 = " \
    file://0001-Revert-Revert-mmc-sdhci-Mask-spurious-interrupts.patch \
"

FILESEXTRAPATHS:prepend:osv-wrlinux := "${EXTRA_KERNEL_FILES}:"
SRC_URI:append:osv-wrlinux = " ${EXTRA_KERNEL_SRC_URI}"
