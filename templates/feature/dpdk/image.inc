IMAGE_INSTALL += " dpdk dpdk-tools dpdk-module"

# NXP dpdk 21.11 supports dpdk-examples, so install this package when building dpdk for NXP ls/lx series platform.
IMAGE_INSTALL:append = " ${@bb.utils.contains('PREFERRED_VERSION_dpdk', '21.11', 'dpdk-examples', '', d)}"
