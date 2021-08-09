COMPATIBLE_HOST:wrlinux-ovp = "(x86_64.*|i.86.*)-linux"
COMPATIBLE_MACHINE:qemux86 = "${MACHINE}"
COMPATIBLE_MACHINE:qemux86-64 = "${MACHINE}"

PACKAGECONFIG:wrlinux-ovp ?= "libvirt"

DPDK_TARGET_MACHINE:qemux86 = "corei7"
DPDK_TARGET_MACHINE:qemux86-64 = "corei7"

DPDK_EXTRA_CFLAGS:append:qemux86 = " -march=corei7"
DPDK_EXTRA_CFLAGS:append:qemux86-64 = " -march=corei7"
