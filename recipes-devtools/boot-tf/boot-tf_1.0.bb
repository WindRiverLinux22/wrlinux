SUMMARY = "Boot svg files to tracing format"
DESCRIPTION = "Convert svg file to tracing file (json), or merge multiple json files into one.\
                The svg file is from systemd-bootchart or 'systemd-analyze plot'"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://boot-tf;beginline=3;endline=5;md5=47704aaf7707f93a6a453d6870a9864e"

SRC_URI = "file://boot-tf \
           file://boot-tf.service"

S = "${WORKDIR}"

INHIBIT_DEFAULT_DEPS = "1"

inherit systemd features_check allarch

REQUIRED_DISTRO_FEATURES = "systemd"

RDEPENDS:${PN} += "systemd-bootchart systemd-analyze python3"

SYSTEMD_SERVICE:${PN} = "boot-tf.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/boot-tf ${D}${bindir}
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/boot-tf.service ${D}${systemd_system_unitdir}
    sed -i -e 's,@BINDIR@,${bindir},g' ${D}${systemd_system_unitdir}/boot-tf.service
}

FILES:${PN} += "${systemd_system_unitdir}"
