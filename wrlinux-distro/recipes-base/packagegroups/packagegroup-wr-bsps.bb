SUMMARY = "Packages required by bsp"

#
# packages which content depend on MACHINE_FEATURES need to be MACHINE_ARCH
#

ALLOW_EMPTY:${PN} = "1"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup


BSP_EXTRAS_PACKAGES ?= ""

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
	    packagegroup-wr-bsps \
            ${@bb.utils.contains("MACHINE_FEATURES", "parser", "packagegroup-wr-bsps-parser", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "shell-tools", "packagegroup-wr-bsps-shell-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "filesystem", "packagegroup-wr-bsps-filesystem-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "profile", "packagegroup-wr-bsps-profile-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "network", "packagegroup-wr-bsps-network-tools", "", d)} \
	    \
	    ${@bb.utils.contains("DISTRO_FEATURES", "bsp-extras", "packagegroup-wr-bsps-bsp-extras", "", d)} \
            '

#
# packagegroup-wr-bsps contain stuff needed by BSPs (machine related)
#
RDEPENDS:packagegroup-wr-bsps = "\
            ${@bb.utils.contains("MACHINE_FEATURES", "parser", "packagegroup-wr-bsps-parser", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "shell-tools", "packagegroup-wr-bsps-shell-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "filesystem", "packagegroup-wr-bsps-filesystem-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "profile", "packagegroup-wr-bsps-profile-tools", "", d)} \
            ${@bb.utils.contains("MACHINE_FEATURES", "network", "packagegroup-wr-bsps-network-tools", "", d)} \
	    \
	    ${@bb.utils.contains("DISTRO_FEATURES", "bsp-extras", "packagegroup-wr-bsps-bsp-extras", "", d)} \
    "

SUMMARY:packagegroup-wr-bsps-parser = "Parser Generator Support"
RDEPENDS:packagegroup-wr-bsps-parser = "\
	flex \
	bison"

SUMMARY:packagegroup-wr-bsps-shell-tools = "Shell tools support"
RDEPENDS:packagegroup-wr-bsps-shell-tools = "\
	dialog"

SUMMARY:packagegroup-wr-bsps-filesystem-tools = "Filesystem tools support"
RDEPENDS:packagegroup-wr-bsps-filesystem-tools = "\
	fio \
	smartmontools"

SUMMARY:packagegroup-wr-bsps-profile-tools = "Profile tools support"
RDEPENDS:packagegroup-wr-bsps-profile-tools = "\
	${@bb.utils.contains('INCOMPATIBLE_LICENSE', 'GPL-3.0-only', '', 'perf', d)}"

SUMMARY:packagegroup-wr-bsps-network-tools = "Network tools support"
RDEPENDS:packagegroup-wr-bsps-network-tools = "\
	iperf3"

SUMMARY:packagegroup-wr-bsps-bsp-extras = "BSP related extras devices tools"
RDEPENDS:packagegroup-wr-bsps-bsp-extras = "\
	${BSP_EXTRAS_PACKAGES} \
	"
