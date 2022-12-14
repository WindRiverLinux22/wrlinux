#
# Copyright (C) 2017 Wind River Systems, Inc.
#

KERNEL_FEATURES += "\
 features/intel-dpdk/intel-dpdk.scc \
"

# Only qemux86 and qemux86-64 is allowed!
TARGET_SUPPORTED_KTYPES:qemux86 = "preempt-rt standard"
TARGET_SUPPORTED_KTYPES:qemux86-64 = "preempt-rt standard"

# Most BSPs provide a compatible_machine override, the distro override
# has a higher priority then machine override so use it to block other
# BSPs.
COMPATIBLE_MACHINE:wrlinux-ovp = "(qemux86|qemux86-64)"

COMPATIBLE_HOST = "(i.86|x86_64).*-linux"

SRCREV_machine = "${AUTOREV}"
SRCREV_meta = "${AUTOREV}"
