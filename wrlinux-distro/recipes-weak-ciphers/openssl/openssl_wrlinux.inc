#
# Copyright (C) 2017 Wind River Systems, Inc.
#

WEAKCIPHERS = "${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', 'no-des', '', d)}"
EXTRA_OECONF:append:class-target:osv-wrlinux = " ${WEAKCIPHERS}"
EXTRA_OECONF:append:class-nativesdk:osv-wrlinux = " ${WEAKCIPHERS}"
