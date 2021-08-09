FILESEXTRAPATHS:prepend:wrlinux-ovp := "${THISDIR}/files:"

SRC_URI:append:wrlinux-ovp = " \
	file://rules-add-kvm-rule.patch \
"

FILES:udev:append:wrlinux-ovp = " ${rootlibexecdir}/udev/rules.d/99-kvm.rules"

PACKAGECONFIG:append:wrlinux-ovp = " resolved"
