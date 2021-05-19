#
# Copyright (C) 2019 Wind River Systems, Inc.
#

EXTRA_OECMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'openssl-no-weak-ciphers', '-DWITH_SSL=bundled', '', d)}"
