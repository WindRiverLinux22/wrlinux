EXTRA_KERNEL_FILES ?= ""
EXTRA_KERNEL_SRC_URI ?= ""
EXTRA_KERNEL_FILES_prepend_bcm-2xxx-rpi4 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_bcm-2xxx-rpi4 = " \
    file://0001-Revert-Revert-mmc-sdhci-Mask-spurious-interrupts.patch \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES_prepend_marvell-cn96xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_marvell-cn96xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump-for-marvell-cn96xx.patch \
"
EXTRA_KERNEL_FILES_prepend_qemuarm64 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_qemuarm64 = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES_prepend_xilinx-zynqmp = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_xilinx-zynqmp = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES_prepend_nxp-imx8 = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_nxp-imx8 = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES_prepend_nxp-s32g2xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_nxp-s32g2xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"
EXTRA_KERNEL_FILES_prepend_ti-j72xx = "${THISDIR}/linux-yocto:"
EXTRA_KERNEL_SRC_URI_append_ti-j72xx = " \
    file://0001-iommu-arm-smmu-v3-Ratelimit-event-dump.patch \
"

FILESEXTRAPATHS_prepend_osv-wrlinux := "${EXTRA_KERNEL_FILES}:"
SRC_URI_append_osv-wrlinux = " ${EXTRA_KERNEL_SRC_URI}"
