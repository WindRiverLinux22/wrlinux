EXTRA_KERNEL_FILES ?= ""
EXTRA_KERNEL_SRC_URI ?= ""
EXTRA_KERNEL_FILES:prepend:bcm-2xxx-rpi4 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:bcm-2xxx-rpi4 = " \
    file://0001-Revert-Revert-mmc-sdhci-Mask-spurious-interrupts.patch \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES:prepend:marvell-cn96xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:marvell-cn96xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump-for-marvell-cn96xx.patch \
"
EXTRA_KERNEL_FILES:prepend:qemuarm64 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:qemuarm64 = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES:prepend:xilinx-zynqmp = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:xilinx-zynqmp = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES:prepend:nxp-imx8 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:nxp-imx8 = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES:prepend:nxp-s32g2xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:nxp-s32g2xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES:prepend:ti-j72xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI:append:ti-j72xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"

FILESEXTRAPATHS:prepend:osv-wrlinux := "${EXTRA_KERNEL_FILES}:"
SRC_URI:append:osv-wrlinux = " ${EXTRA_KERNEL_SRC_URI}"
