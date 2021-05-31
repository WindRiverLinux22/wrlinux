#
# Copyright (C) 2021 Wind River Systems, Inc.
#

CONFIGSSL = "${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', 'ssl', '', d)}"
CONFIGGNUTLS = "${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', 'gnutls', '', d)}"

PACKAGECONFIG_remove_osv-wrlinux = " ${CONFIGSSL}"
PACKAGECONFIG_append_osv-wrlinux = " ${CONFIGGNUTLS}"
