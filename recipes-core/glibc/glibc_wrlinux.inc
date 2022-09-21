FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
    ${@bb.utils.contains('PACKAGECONFIG', 'POSIX_26', 'file://0001-Add-support-for-posix_devctl.patch', '', d)} \
"

PACKAGECONFIG[POSIX_26] = ",,,"

# For Distro only
GLIBC_GETLOADER64 ?= ""
python() {
    bbincluded = (d.getVar('BBINCLUDED') or '').split()
    skip = '/wrlinux-bin-image.conf'
    for i in bbincluded:
        if i.endswith(skip):
            skip = ''
            break
    if skip:
        return

    multilibs = d.getVar('MULTILIBS')
    if not multilibs:
        glibc_getloader = d.getVar('GLIBC_GETLOADER')
        glibc_getloader64 = glibc_getloader.replace('/lib/', '/lib64/')
        if glibc_getloader64 != glibc_getloader:
            d.setVar('GLIBC_GETLOADER64', glibc_getloader64)
            d.appendVar('FILES:%s' % d.getVar('PN'), ' %s' % glibc_getloader64)
            if bb.utils.contains('DISTRO_FEATURES','usrmerge',True,False,d):
                d.appendVar('FILES:%s' % d.getVar('PN'), ' /lib64')
}

do_install:append() {
    # The ld is /usr/lib64/ld-linux-x86-64.so.2 when multilib is enabled, and
    # is /usr/lib/ld-linux-x86-64.so.2 when mutilib is not enabeld, Distro
    # doesn't enable mutilib, so create a symlink
    # /usr/lib64/ld-linux-x86-64.so.2 to /usr/lib/ld-linux-x86-64.so.2 (or
    # /lib64/ld-linux-x86-64.so.2 when usrmerge is enabled) for compatibility.
    if [ -n "${GLIBC_GETLOADER64}" ]; then
        loader64_dir=$(dirname ${GLIBC_GETLOADER64})
        install -d ${D}$loader64_dir
        ln --relative --symbolic ${D}${GLIBC_GETLOADER} ${D}${GLIBC_GETLOADER64}
        if ${@bb.utils.contains('DISTRO_FEATURES','usrmerge','true','false',d)}; then
            ln --relative --symbolic ${D}$loader64_dir ${D}/lib64
        fi
    fi
}
# End Distro
