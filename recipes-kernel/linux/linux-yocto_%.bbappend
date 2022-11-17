LINUX-YOCTO_INC_WRLINUX = ""
SRCREV_INC_WRLINUX = ""
EXTRA_SRCREV_INC_WRLINUX = ""
LINUX-YOCTO_INC_WRLINUX:osv-wrlinux = "linux-yocto-wrlinux.inc"
SRCREV_INC_WRLINUX:osv-wrlinux = "srcrev.inc"
EXTRA_SRCREV_INC_WRLINUX:osv-wrlinux = "linux-yocto-extra-kernel-src.inc"
require ${LINUX-YOCTO_INC_WRLINUX}
include ${SRCREV_INC_WRLINUX}
require ${EXTRA_SRCREV_INC_WRLINUX}

KERNEL_VERSION_SANITY_SKIP:osv-wrlinux ?= "1"
