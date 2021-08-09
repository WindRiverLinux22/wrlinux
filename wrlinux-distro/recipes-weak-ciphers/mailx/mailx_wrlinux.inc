#
# Copyright (C) 2017 Wind River Systems, Inc.
#

FILESEXTRAPATHS:prepend := "${THISDIR}/mailx:"

SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', 'file://mailx-openssl-no-des.patch', '', d)}"
