SUMMARY = "Boot svg files to tracing format"
DESCRIPTION = "Convert svg file to tracing file (json), or merge multiple json files into one.\
                The svg file is from systemd-bootchart or 'systemd-analyze plot'"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://boot-tf;beginline=3;endline=5;md5=47704aaf7707f93a6a453d6870a9864e \
    file://bootlogConst.py;beginline=3;endline=5;md5=33047b843311917876019c26a2ef0d7f \
    file://bootlogParser.py;beginline=6;endline=10;md5=b3c8a4ff191ec4429fa780a9db3a7f0e \
    "

SRC_URI = "file://boot-tf \
           file://boot-tf.service \
           file://bootlogConst.py \
           file://bootlogParser.py \
"

S = "${WORKDIR}"

INHIBIT_DEFAULT_DEPS = "1"

inherit systemd features_check allarch python3-dir

REQUIRED_DISTRO_FEATURES = "systemd"

RDEPENDS:${PN} += "systemd-bootchart systemd-analyze python3 tftpy"

SYSTEMD_SERVICE:${PN} = "boot-tf.service"

# Download vxworks logs from a tftp server, the format is like "--vxworks 10.0.0.1"
BOOT_TF_VX_DOWNLOAD ??= ""

# Upload logs to a tftp server, the format is like "--upload 10.0.0.1"
BOOT_TF_UPLOAD ??= ""

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/boot-tf ${D}${bindir}
    install -m 0755 ${WORKDIR}/bootlogConst.py ${D}${bindir}
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    install -m 0644 ${WORKDIR}/bootlogParser.py ${D}${PYTHON_SITEPACKAGES_DIR}
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/boot-tf.service ${D}${systemd_system_unitdir}
    sed -i -e 's,@BINDIR@,${bindir},g' ${D}${systemd_system_unitdir}/boot-tf.service
    sed -i -e 's,@BOOT_TF_VX_DOWNLOAD@,${BOOT_TF_VX_DOWNLOAD},g' ${D}${systemd_system_unitdir}/boot-tf.service
    sed -i -e 's,@BOOT_TF_UPLOAD@,${BOOT_TF_UPLOAD},g' ${D}${systemd_system_unitdir}/boot-tf.service
}

FILES:${PN} += "${systemd_system_unitdir} \
                ${PYTHON_SITEPACKAGES_DIR} \
                "
