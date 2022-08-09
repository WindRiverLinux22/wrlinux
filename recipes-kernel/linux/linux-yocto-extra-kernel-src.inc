EXTRA_KERNEL_FILES ?= ""
EXTRA_KERNEL_SRC_URI ?= ""
EXTRA_KERNEL_FILES:prepend = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:pn-linux-yocto-rt = " \
    file://0001-sched-deadline-Use-printk_once-instead-of-missing-pr.patch \
"
EXTRA_KERNEL_FILES:prepend:bcm-2xxx-rpi4 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:bcm-2xxx-rpi4 = " \
    file://0001-Revert-Revert-mmc-sdhci-Mask-spurious-interrupts.patch \
"

FILESEXTRAPATHS:prepend:osv-wrlinux := "${EXTRA_KERNEL_FILES}:"
SRC_URI:append:osv-wrlinux = " ${EXTRA_KERNEL_SRC_URI}"
