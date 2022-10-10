#
# Copyright (C) 2022 Wind River Systems, Inc.
#

DEPENDS += "apache2-native"
do_install:append () {
    if [ "${REGISTRY_USER}" != "" ] && [ "${REGISTRY_PWD}" != "" ]; then
        htpasswd -Bbn ${REGISTRY_USER} ${REGISTRY_PWD} > ${D}${sysconfdir}/registry
    fi
}

FILES:docker-registry += "${sysconfdir}/registry"


