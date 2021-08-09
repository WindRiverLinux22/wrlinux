#
# Copyright (C) 2017 - 2018 Wind River Systems, Inc.
#

FILESEXTRAPATHS:prepend := "${THISDIR}/postgresql:"

SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', 'file://0001-postgresql-fix-openssl-no-des.patch', '', d)}"
