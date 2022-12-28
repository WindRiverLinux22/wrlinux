FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://dhcpcd.service \
            file://dhcpcd-systemd-wrapper \
            file://dhcpcd-default \
           "

do_install:append () {
    install -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/dhcpcd-default ${D}${sysconfdir}/default/dhcpcd

    install -d ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/dhcpcd-systemd-wrapper ${D}${base_sbindir}/dhcpcd-systemd-wrapper

    sed -i -e 's,@SYSCONFDIR@,${sysconfdir},g' ${D}${systemd_unitdir}/system/dhcpcd.service
    sed -i -e 's,@SBINDIR@,${base_sbindir},g' ${D}${systemd_unitdir}/system/dhcpcd.service
}
