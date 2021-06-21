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
    file://0001-Revert-net-xfrm-fixup-5.10.30-stable-merge.patch \
    file://0001-aufs-fix-compile-failure-when-accessing-rw_sem.owner.patch \
"
