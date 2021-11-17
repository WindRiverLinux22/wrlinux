#
# Copyright (C) 2020 Wind River Systems, Inc.
#
DESCRIPTION = "Provides container base app sdk for Wind River Linux Assembly Tool."

# Control the installed packages strictly
WRTEMPLATE_IMAGE = "0"

require recipes-support/image/lat-sdk_1.0.bb

SDK_VERSION = "${WRLINUX_PRODUCT_VERSION}"
TOOLCHAIN_OUTPUTNAME = "${DISTRO}-${DISTRO_VERSION}-${TCLIBC}-${SDK_ARCH}${TCSDKMACH}-${MACHINE_ARCH}-${PN}-sdk"
