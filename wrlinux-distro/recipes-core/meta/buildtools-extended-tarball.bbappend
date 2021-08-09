# This file is duplicated from ./buildtools-tarball.bbappend
BUILDTOOLS = "buildtools-extended"
BUILDTOOLS_TARBALL_INC_WRLINUX = ""
BUILDTOOLS_TARBALL_INC_WRLINUX:osv-wrlinux = "buildtools-tarball_wrlinux.inc"
BUILDTOOLS_TARBALL_INC_WRLINUX:remove_nodistro = "buildtools-tarball_wrlinux.inc"
BUILDTOOLS_TARBALL_INC_WRLINUX:remove_wrlinux-overc = "buildtools-tarball_wrlinux.inc"
BUILDTOOLS_TARBALL_INC_WRLINUX:remove_overc = "buildtools-tarball_wrlinux.inc"
require ${BUILDTOOLS_TARBALL_INC_WRLINUX}
