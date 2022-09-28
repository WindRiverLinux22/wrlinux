require linux-yocto-wrlinux.inc
include srcrev.inc
require linux-yocto-extra-kernel-src.inc

TARGET_SUPPORTED_KTYPES:append:qemuall = " preempt-rt"

# qemuarma9 doesn't support preempt-rt.
TARGET_SUPPORTED_KTYPES:remove:qemuarma9 = "preempt-rt"

KERNEL_VERSION_SANITY_SKIP ?= "1"
