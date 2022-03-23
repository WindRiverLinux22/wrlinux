DESCRIPTION = "Virtual/monitoring for zabbix packages"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

require packagegroup-monitoring.inc

RDEPENDS:${PN} += "zabbix"
