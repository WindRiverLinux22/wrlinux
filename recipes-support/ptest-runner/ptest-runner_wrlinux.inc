#
# Copyright (C) 2012-2013 Wind River Systems, Inc.
#
# LOCAL REV: WR specific simics related patches
#
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://ptest-summary.sh "
SRC_URI:append = " file://ptest-diff.sh "

do_install:append () {
        install -m 0755 ${WORKDIR}/ptest-summary.sh ${D}${bindir}/
        install -m 0755 ${WORKDIR}/ptest-diff.sh ${D}${bindir}/
}

RDEPENDS:${PN} += "bash"
FILES:${PN} += "${bindir}"
