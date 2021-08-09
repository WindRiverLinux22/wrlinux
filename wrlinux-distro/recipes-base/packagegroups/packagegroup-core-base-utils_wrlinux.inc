#
# Copyright (C) 2016 Wind River Systems Inc.
#

RDEPENDS:${PN}:append:osv-wrlinux = " \
    bc \
    debianutils-run-parts \
    dpkg-start-stop \
    fbset \
    kbd \
    netcat \
    ifupdown \
    iputils-ping \
    usleep \
    util-linux-flock \
    util-linux-mount \
    "
