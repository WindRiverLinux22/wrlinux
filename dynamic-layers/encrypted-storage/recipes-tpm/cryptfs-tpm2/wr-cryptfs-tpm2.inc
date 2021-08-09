FILESEXTRAPATHS:append := ":${THISDIR}/files"

SRC_URI += " \
	file://init.luks \
	"

do_install:append() {
    install -m 0500 "${WORKDIR}/init.luks" "${D}"

    rm -rf "${D}/init.cryptfs"
}

FILES:${PN}-initramfs += "/init.luks"
FILES:${PN}-initramfs:remove += "/init.cryptfs"

RDEPENDS:${PN} += " \
		rng-tools \
		findutils \
		pv \
		gzip \
		tar \
		parted \
		e2fsprogs-tune2fs \
		e2fsprogs-mke2fs \
		util-linux-blkid \
		util-linux-lsblk \
	"
