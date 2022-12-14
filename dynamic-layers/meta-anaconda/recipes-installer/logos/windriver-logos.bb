DESCRIPTION = "Wind River logos for branding"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe"

SRC_URI = "file://sidebar-logo.png \
           file://sidebar-bg.png \
           file://topbar-bg.png \
           ${@oe.utils.conditional('WRLINUX_BRANCH', 'LTS', 'file://banner_windriver_LTS.png', 'file://banner_windriver.png', d)} \
           file://COPYING"

S = "${WORKDIR}"

inherit allarch

FILES:${PN} = "${datadir}/anaconda"

do_install() {
    install -d ${D}/${datadir}/anaconda/boot
    install -d ${D}/${datadir}/anaconda/pixmaps
    install -m 0755 sidebar-logo.png ${D}${datadir}/anaconda/pixmaps
    install -m 0755 sidebar-bg.png ${D}${datadir}/anaconda/pixmaps
    install -m 0755 topbar-bg.png ${D}${datadir}/anaconda/pixmaps
    install -d ${D}/${datadir}/anaconda/pixmaps/rnotes/en
    install -m 0755 banner_*.png ${D}/${datadir}/anaconda/pixmaps/rnotes/en
}
