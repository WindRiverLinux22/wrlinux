#
# Copyright (C) 2012 Wind River Systems Inc.
#
# This package matches a FEATURE_PACKAGES_packagegroup-wr-core-security definition in
# core-image.bbclass that may be used to customize an image by
# adding "wr-core-security" to IMAGE_FEATURES.
#

DESCRIPTION = "Wind River Linux core package group: security"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "\
  file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
  file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420 \
  "

PR = "r2"

PACKAGES = "${PN}-utils ${PN}-trust \ 
            ${PN}-access ${PN}-detection \
            ${PN}-crypto ${PN}-auth ${PN}"

ALLOW_EMPTY:${PN}-utils = "1"
ALLOW_EMPTY:${PN}-trust = "1"
ALLOW_EMPTY:${PN}-access = "1"
ALLOW_EMPTY:${PN}-detection = "1"
ALLOW_EMPTY:${PN}-crypto = "1"
ALLOW_EMPTY:${PN}-auth = "1"
ALLOW_EMPTY:${PN} = "1"

# afong: These two were originally in the package list, no apps were using them, removed.
# 	libgssglue
# 	libmhash
RDEPENDS:${PN} = "\
	${PN}-utils \
	${PN}-trust \
	${PN}-access \
	${PN}-detection \
	${PN}-crypto \
	${PN}-auth \
        "

RDEPENDS:${PN}-utils = "\
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'integrity', 'keyutils', '', d)} \
	nspr \
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'security', 'xmlsec1', '', d)} \
        "

RDEPENDS:${PN}-trust = "\
	gnupg \
        "

RDEPENDS:${PN}-access = "\
	${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'audit auditd', '', d)} \
        "

RDEPENDS:${PN}-detection = "\
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'security', 'samhain', '', d)} \
        "

RDEPENDS:${PN}-crypto = "\
	${@bb.utils.contains('BBFILE_COLLECTIONS', 'security', 'ecryptfs-utils', '', d)} \
	gnutls \
	nss \
        "

RDEPENDS:${PN}-auth = "\
	krb5 \
	pinentry \
        "

# jjmac: (2012.05.17)
#       Due back in security-core when package upreves are complete.
#        pyetree
