SUMMARY = "Mobile IPv6 and NEMO for Linux"
DESCRIPTION = "UMIP is an open source implementation of Mobile IPv6 and NEMO \
Basic Support for Linux. It is released under the GPLv2 license. It supports \
the following IETF RFC: RFC6275 (Mobile IPv6), RFC3963 (NEMO), RFC3776 and \
RFC4877 (IPsec and IKEv2)."
HOMEPAGE = "http://umip.org/"
SECTION = "System Environment/Base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=073dc31ccb2ebed70db54f1e8aeb4c33"

DEPENDS = "openssl indent-native bison-native"

SRC_URI = "file://umip-1.0.tar.gz \
           file://0001-add-dependency-to-support-parallel-compilation.patch \
           file://0002-Add-format-string-to-fprintf-call.patch \
           file://0003-replace-SIGCLD-with-SIGCHLD-and-include-sys-types.h.patch \
           file://0004-replace-PTHREAD_MUTEX_FAST_NP-with-PTHREAD_MUTEX_NOR.patch \
           file://0005-support-openssl-1.1.x.patch \
           file://mip6d \
           file://mip6d.service \
           "

S = "${WORKDIR}/umip"

EXTRA_OECONF = "--enable-vt"

inherit autotools-brokensep systemd update-rc.d

INITSCRIPT_NAME = "mip6d"
INITSCRIPT_PARAMS = "start 64 . stop 36 0 1 2 3 4 5 6 ."

SYSTEMD_SERVICE:${PN} = "mip6d.service"
SYSTEMD_AUTO_ENABLE = "disable"

do_install:append() {
    install -D -m 0755 ${WORKDIR}/mip6d ${D}${sysconfdir}/init.d/mip6d
    install -D -m 0644 ${WORKDIR}/mip6d.service ${D}${systemd_system_unitdir}/mip6d.service
    sed -i -e 's,@SYSCONFDIR@,${sysconfdir},g' \
        -e 's,@SBINDIR@,${sbindir},g' \
        ${D}${systemd_system_unitdir}/mip6d.service
}

RRECOMMENDS:${PN} = "kernel-module-mip6 kernel-module-ipv6"
