#
# Copyright (C) 2015 - 2017 Wind River Systems, Inc.
#

# Remove systemtap from RDEPENDS
# Systemtap is NOT supported, perf is the preferred tool for system-wide debug
SYSTEMTAP:osv-wrlinux = ""

# We have to do this, too, because a bbappend in yocto-bsps explicitly adds systemtap.
RDEPENDS:${PN}:remove:osv-wrlinux = "systemtap"

# Valgrind only works on powerpc w/o an SPE.
VALGRIND:powerpc = "${@bb.utils.contains("HOST_SYS","powerpc-wrs-linux-gnuspe","","valgrind",d)}"
