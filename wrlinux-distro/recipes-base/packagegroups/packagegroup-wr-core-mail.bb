#
# Copyright (C) 2013 Wind River Systems Inc.
#
# This package matches a FEATURE_PACKAGES_packagegroup-wr-core-mail definition in
# wrlinux-image.bbclass that may be used to customize an image by
# adding "wr-core-mail" to IMAGE_FEATURES.
#

DESCRIPTION = "Wind River Linux core package group: mail"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

ALLOW_EMPTY:${PN} = "1"

RDEPENDS:${PN} = " \
    postfix \
    "
