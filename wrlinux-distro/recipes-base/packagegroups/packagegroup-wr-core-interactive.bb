#
# Copyright (C) 2012-2013 Wind River Systems Inc.
#
# This package matches a FEATURE_PACKAGES_packagegroup-wr-core-interactive definition in
# wrlinux-image.bbclass that may be used to customize an image by
# adding "wr-core-interactive" to IMAGE_FEATURES.
#

DESCRIPTION = "Wind River Linux core package group: interactive"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r1"

ALLOW_EMPTY:${PN} = "1"

RDEPENDS:${PN} = " \
    lrzsz \
    man \
    man-pages \
    minicom \
    ncurses-tools \
    vim \
    vim-common \
    vim-syntax \
    ${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPL-3.0-or-later', '', 'screen', d)} \
    "
