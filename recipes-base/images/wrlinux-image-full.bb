#
# Copyright (C) 2020 - 2021 Wind River Systems, Inc.
#
DESCRIPTION = "A full functional image that boots to a console."

require wrlinux-bin-image.inc

TARGET_CORE_BOOT ?= " \
    kernel-modules \
    packagegroup-core-boot \
    gsettings-desktop-schemas \
"

IMAGE_INSTALL += "\
    ${@bb.utils.contains('IMAGE_ENABLE_CONTAINER', '1', '${CONTAINER_CORE_BOOT}', '${TARGET_CORE_BOOT}', d)} \
    openssh \
    ca-certificates \
    "

# Remove debug-tweaks
IMAGE_FEATURES:remove = "debug-tweaks"

# Remove x11 packages since the board doesn't support graphic display
IMAGE_FEATURES:remove_intel-socfpga-64 = "x11-base"
IMAGE_INSTALL:remove_intel-socfpga-64 = "packagegroup-xfce-extended wr-themes"

IMAGE_FEATURES:remove:nxp-s32g = "x11-base"
IMAGE_INSTALL:remove:nxp-s32g = "packagegroup-xfce-extended wr-themes"

IMAGE_FEATURES:remove:xilinx-zynq = "x11-base"
IMAGE_INSTALL:remove:xilinx-zynq = "packagegroup-xfce-extended wr-themes"

IMAGE_FEATURES:remove:ti-j72xx = "x11-base"
IMAGE_INSTALL:remove:ti-j72xx = "packagegroup-xfce-extended wr-themes"

IMAGE_FEATURES:remove:marvell-cn96xx = "x11-base"
IMAGE_INSTALL:remove:marvell-cn96xx = "packagegroup-xfce-extended wr-themes"

# Enable dhcpcd service if NetworkManager is not installed.
ROOTFS_POSTPROCESS_COMMAND += "enable_dhcpcd_service; "
enable_dhcpcd_service() {
    if [ ! -e ${IMAGE_ROOTFS}${sbindir}/NetworkManager \
        -a -f ${IMAGE_ROOTFS}${systemd_unitdir}/system/dhcpcd.service ]; then
        ln -sf ${systemd_unitdir}/system/dhcpcd.service \
            ${IMAGE_ROOTFS}${sysconfdir}/systemd/system/multi-user.target.wants/dhcpcd.service
    fi
}
