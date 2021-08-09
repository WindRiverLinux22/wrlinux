FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI:append = " file://wr-init"

do_install:append() {
    rm -rf "${D}/init"
    install -m 0755 "${WORKDIR}/wr-init" "${D}/init"
}
