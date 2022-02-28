#
# Copyright (C) 2015 Wind River Systems, Inc.
#

OVERRIDES .= "${@bb.utils.contains('LICENSE_FLAGS_ACCEPTED', 'commercial_windriver', ':wr-themes', '', d)}"

DEFAULT_WALLPAPER ?= "gray"

LICENSE_FLAGS:wr-themes = "commercial_windriver"

do_compile:prepend:wr-themes () {
	# we have several wallpapers for each theme, use the first one by default
	sed -i "s,\(/backgrounds/\)[-_/\.a-zA-Z0-9]*,\1Windriver/windriver-${DEFAULT_WALLPAPER}-1.jpg," \
		${S}/common/xfdesktop-common.h
}

RDEPENDS:${PN}:append:wr-themes = " wr-themes-wallpapers"
