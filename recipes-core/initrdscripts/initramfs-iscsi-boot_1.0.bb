SUMMARY = "initramfs for iSCSI boot"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "file://init-iscsi.sh \
           file://iscsi-boot.service \
          "

do_install() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'iscsi-boot', 'true', 'false', d)}; then
        install -m 0755 ${WORKDIR}/init-iscsi.sh ${D}/init-iscsi.sh
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/iscsi-boot.service ${D}${systemd_unitdir}/system/
    fi
}

SYSTEMD_SERVICE:${PN} = "iscsi-boot.service"

FILES:${PN} += " /init-iscsi.sh"
COMPATIBLE_MACHINE = "intel-x86-64"
