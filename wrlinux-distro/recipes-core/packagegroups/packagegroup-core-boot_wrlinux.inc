#
# Copyright (C) 2012-2013 Wind River Systems, Inc.
#

PACKAGES:append:osv-wrlinux = " packagegroup-wr-boot"

WR_MACHINE_ESSENTIAL_EXTRA_RDEPENDS ?= ""
ALLOW_EMPTY:packagegroup-wr-boot:osv-wrlinux = "1"
RDEPENDS:packagegroup-wr-boot:osv-wrlinux = "${PN} ${WR_MACHINE_ESSENTIAL_EXTRA_RDEPENDS}"

# add wr-init
RDEPENDS:${PN}:append:osv-wrlinux = " wr-init"

# Need these, but images may choose to pull them from various
# packages, e.g. busybox or bash+busybox-oe-min.
# The following only works with the RPM backend...
FILERDEPENDS_${PN}:osv-wrlinux = "/bin/sh /usr/bin/run-parts /sbin/start-stop-daemon /sbin/ifup"

# override the default in package-core-boot.bb
EFI_PROVIDER ??= "${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPL-3.0-only', '', 'grub-efi', d)}"
