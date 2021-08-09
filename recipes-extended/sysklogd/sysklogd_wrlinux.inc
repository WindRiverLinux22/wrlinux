#
# Copyright (C) 2012 Wind River Systems, Inc.
#
# LOCAL REV:
#
# Port debian logrotate.d entries to enable log rotation/expiration
# on WR images.
#
# Upstream-status: pending: parse_syslog_conf.patch

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://syslog.logrotate"

do_install:append () {
	install -d ${D}${sysconfdir}/logrotate.d
	install -m 644 ${WORKDIR}/syslog.logrotate \
		${D}${sysconfdir}/logrotate.d/syslog
}

# logrotate sub-package
PACKAGES =+ "${PN}-logrotate"
RDEPENDS:${PN}-logrotate = "sysklogd logrotate"
RCONFLICTS:${PN}-logrotate = "syslog-ng-logrotate"
FILES:${PN}-logrotate = "${sysconfdir}/logrotate.d/syslog"
