require linux-yocto-wrlinux.inc
include srcrev.inc
require linux-yocto-extra-kernel-src.inc

TARGET_SUPPORTED_KTYPES_append_qemuall = " preempt-rt"

# qemuarma9 doesn't support preempt-rt.
TARGET_SUPPORTED_KTYPES_remove_qemuarma9 = "preempt-rt"

SRCREV_machine = "${AUTOREV}"
SRCREV_meta = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:"
SRC_URI_append = " \
    file://0001-xfrm-fix-up-warning-introduced-by-pseudo-revert.patch \
"
