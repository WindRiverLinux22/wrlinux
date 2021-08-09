#
# Copyright (C) 2012-2017 Wind River Systems, Inc.
#

FILESEXTRAPATHS:prepend:wrlinux-ovp := "${THISDIR}/acpid:"

SRC_URI:append:wrlinux-ovp = " \
            file://powerbtn \
            file://power.sh \
           "

# reorder to prevent ${PN} from picking up -default-scripts files
PACKAGES:wrlinux-ovp = "${PN}-dbg ${PN}-staticdev ${PN}-dev ${PN}-doc ${PN}-locale ${PN}-default-scripts ${PN}"

RDEPENDS:${PN}-default-scripts += "${BPN}"
FILES:${PN}-default-scripts = " \
    ${sysconfdir}/acpi/events/powerbtn \
    ${sysconfdir}/acpi/actions/power.sh \
    "

do_install:append:wrlinux-ovp () {
	install -d ${D}${sysconfdir}/acpi/events
	install -m 0444 ${WORKDIR}/powerbtn ${D}${sysconfdir}/acpi/events/.
	install -d ${D}${sysconfdir}/acpi/actions
	install -m 0755 ${WORKDIR}/power.sh ${D}${sysconfdir}/acpi/actions/.
}
