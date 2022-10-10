SYSTEMD_PACKAGES += "chronyc"
SYSTEMD_SERVICE:chronyc = "chrony-wait.service"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}/${systemd_unitdir}/system
        install -m 0644 ${S}/examples/chrony-wait.service ${D}/${systemd_unitdir}/system/
    fi  

    sed -i -e '/^#server .*/aserver ${CUSTOM_NTP_SERVER} iburst prefer' \
        ${D}${sysconfdir}/chrony.conf
}

FILES:chronyc += "${systemd_unitdir}/system/chrony-wait.service"
