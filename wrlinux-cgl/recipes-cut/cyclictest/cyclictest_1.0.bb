#
# Copyright (C) 2013 Wind River Systems, Inc.
#
SUMMARY = "cyclictest"
DESCRIPTION = "The cyclictest package contains a Hello World program"
SECTION = "apps"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

SRC_URI = "\
	file://files/COPYING \
	file://files/cyclic-test \
	file://files/cyclictest.c \
	file://files/Makefile \
	"

do_patch() {
	cp -r ${WORKDIR}/files/* ${S}
}

do_install() {
	mkdir -p ${D}/opt/cut/bin
	install -m 0755 ${S}/cyclictest ${D}/opt/cut/bin

	mkdir -p ${D}/opt/cut/scripts
	install -m 0755 ${S}/cyclic-test ${D}/opt/cut/scripts
}

# cyclic-test needs this
#
RDEPENDS:${PN} += "bash"

FILES:${PN} += "/opt/cut/*"
FILES:${PN}-dbg += "/opt/cut/bin/.debug"
