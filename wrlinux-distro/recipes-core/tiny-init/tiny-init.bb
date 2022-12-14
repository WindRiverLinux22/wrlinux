SUMMARY = "tiny init"
DESCRIPTION = "Basic init system for tiny"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r3"

RDEPENDS:${PN} = "busybox"

SRC_URI = "file://init \
	   file://rc.local.sample \
	  "

do_configure() {
	:
}

do_compile() {
	:
}

do_install() {
	install -d ${D}${sysconfdir} ${D}${base_sbindir}
	install -m 0755 ${WORKDIR}/init ${D}
	ln -sf /init ${D}${base_sbindir}/init
	install -m 0755 ${WORKDIR}/rc.local.sample ${D}${sysconfdir}
}

FILES:${PN} = "/init ${base_sbindir}/init ${sysconfdir}/rc.local.sample"
