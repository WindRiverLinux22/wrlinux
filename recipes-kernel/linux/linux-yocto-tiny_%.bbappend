require linux-yocto-wrlinux.inc
include srcrev.inc
require extra-kernel-src.inc

TARGET_SUPPORTED_KTYPES:append:qemux86 = " tiny"
