FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

#
# handle ip=xxx kernel parameter for /etc/resolv.conf,
# NM treats the configured network device as 'externally'
#
SRC_URI += " \
    file://eth0-ip-cmdline.sh \
"
do_install:append() {
    install -m 0755 ${WORKDIR}/eth0-ip-cmdline.sh ${D}${sysconfdir}/NetworkManager/dispatcher.d/
}
