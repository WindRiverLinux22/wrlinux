IMAGE_INSTALL += " dpdk dpdk-tools dpdk-module"

# nxp dpdk 21.11 doesn't have dpdk-tools. SO, remove it when build dpdk for NXP ls/lx series platform.
IMAGE_INSTALL:remove = "${@bb.utils.contains('PREFERRED_VERSION_dpdk', '21.11', 'dpdk-tools', '', d)}"
