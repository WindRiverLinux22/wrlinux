# Copyright (C) 2015 Wind River Systems, Inc.
#
FILESEXTRAPATHS:prepend:df-cgl := "${THISDIR}/systemd:"

SRC_URI:append:df-cgl = " \
       file://add-a-interface-to-skip-automount-devtmpfs-to-dev-pa.patch \
	"

